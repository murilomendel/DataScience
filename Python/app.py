import streamlit as st
import pandas as pd
import numpy as np
import random
import json
import plotly.express as px

st.set_page_config(page_title="Default Page", layout="wide")

# Sidebar
st.sidebar.title("Navigation")
st.sidebar.write("This is the side panel.")

# Main page
st.title("Welcome to the Default Page")
st.write("This is the main content area of your Streamlit app.")

# Prepare the data
df = pd.DataFrame({
    'date_ref': [202503, 202502, 202501, 202412, 202411, 202410, 202409, 202408, 202407, 202406],
    'cod_gpe': ['4815150'] * 10,
    'membros': [
        ['4815150', '5772682', '58134221'],
        ['4815150', '5772682', '58134221'],
        ['4815150', '5772682', '58134221'],
        ['4815150', '5772682', '58134221'],
        ['4815150', '5772682'],
        ['4815150', '5772682'],
        ['4815150', '5772682'],
        ['4815150', '5772682'],
        ['4815150', '5772682'],
        ['4815150', '5772682']
    ],
    'membros_count': [3, 3, 3, 3, 2, 2, 2, 2, 2, 2],
    'entrada': [[], [], [], ['58134221'], [], [], [], [], [], []],
    'saida': [[], [], [], [], [], [], [], [], [], []],
    'rating_gpe': ['B1', 'B1', 'B1', 'A1', 'A1', 'A1', 'Baa4', 'Baa4', 'C3', 'C3'],
    'rating_ovrd': ['B1', 'B1', 'C1', 'Ba5', 'Ba5', 'A1', 'Baa4', 'H', 'H', 'C3'],
    'rating_ind': json.dumps(
        {'4815150': json.dumps({'rating': ['A1', 'A1', 'A4', 'A4', 'A1', 'A1', 'Baa4', 'Baa4', 'F2', 'F2'],
                                'cod_modelo': ['1508'] * 10,
                                '%_gpe': [0.62, 0.63, 0.60, 0.65, 0.73, 0.72, 0.74, 0.75, 0.74, 0.78]}),
         '5772682': json.dumps({'rating': ['B1', 'B1', 'B1', 'B1', 'B1', 'B1', 'B3', 'B3', 'C2', 'C2'],
                                'cod_modelo': ['1508'] * 10,
                                '%_gpe': [0.33, 0.30, 0.30, 0.24, 0.27, 0.28, 0.26, 0.25, 0.26, 0.22]}),
         '58134221': json.dumps({'rating': ['C1', 'C1', 'C2', 'C3', None, None, None, None, None, None],
                                'cod_modelo': ['4981', '4981', '4981', '1508', None, None, None, None, None, None],
                                '%_gpe': [0.05, 0.07, 0.10, 0.11, None, None, None, None, None, None]})
        }),
    })


# Parse rating_ind JSON
rating_ind = json.loads(df['rating_ind'][0])

all_dates = df['date_ref'].tolist()
all_members = sorted(set(m for sublist in df['membros'] for m in sublist))
timeline_data = []
for member in all_members:
    member_active = []
    for idx, row in df.iterrows():
        member_active.append(member in row['membros'])
    timeline_data.append(member_active)
timeline_df = pd.DataFrame(timeline_data, index=all_members, columns=all_dates).T
timeline_df_plot = timeline_df.astype(int)

st.dataframe(df)

# Visualization Expander with Toggle
with st.expander("#1 - Interactive Filters"):
    st.markdown("**Interactive Filters:** See group composition by date. Toggle to show individual ratings or checkmarks for presence. Each column is a member. Last columns: Qtd., Rating.")

    # Checkbox to toggle visualization mode
    show_ratings = st.checkbox("Show ratings instead of checkmarks", value=False)

    # Build a DataFrame for display
    display_rows = []
    for i, row in df.iterrows():
        row_dict = {"Date": str(row["date_ref"])[:4] + "-" + str(row["date_ref"])[4:6]}
        for member in all_members:
            if show_ratings:
                # Get rating_ind for this member from the parsed rating_ind dictionary
                member_ratings = json.loads(rating_ind[member]) if isinstance(rating_ind[member], str) else rating_ind[member]
                rating = member_ratings["rating"][i] if member in row["membros"] and member_ratings["rating"][i] is not None else "-"
                row_dict[member] = rating
            else:
                row_dict[member] = "✅" if member in row["membros"] else "❌"
        row_dict["Qtd."] = row["membros_count"]
        row_dict["Rating"] = row["rating_gpe"]
        display_rows.append(row_dict)

    display_df = pd.DataFrame(display_rows)

    # Center all values and autosize columns
    st.dataframe(
        display_df.style.set_properties(**{
            'text-align': 'center'
        }).set_table_styles(
            [{'selector': 'th', 'props': [('text-align', 'center')]}]
        ),
        use_container_width=True
    )

with st.expander("#1b - Ratings Timeline Chart"):
    st.markdown(
        "**Interactive Ratings Timeline:** Select which members to plot. "
        "Each point is a rating (full circle). The black line is the group override rating, and the dashed line is the group base rating."
    )

    # Line shape options
    line_shape_options = {
        "Linear": "linear",
        "Spline": "spline",
        "HVH": "hvh",
        "VHV": "vhv",
        "HV": "hv",
        "VH": "vh"
    }
    selected_line_shape = st.selectbox(
        "Select line shape for the chart",
        options=list(line_shape_options.keys()),
        index=0
    )
    line_shape_value = line_shape_options[selected_line_shape]

    # Map ratings to numbers
    rating_map = {
        'A1': 1, 'A4': 2, 'Baa4': 3, 'Ba5': 4, 'B1': 5, 'B3': 6, 'B4': 7,
        'C1': 8, 'C2': 9, 'C3': 10, 'D1': 11, 'D2': 12, 'D3': 13, 'D4': 14,
        'E1': 15, 'E3': 16, 'F2': 17, 'H': 18
    }

    # Parse rating_ind JSON for each member as a dict of lists
    parsed_rating_ind = {}
    for member, val in rating_ind.items():
        if isinstance(val, str):
            parsed_rating_ind[member] = json.loads(val)
        else:
            parsed_rating_ind[member] = val

    # Prepare data for plotting
    plot_dates = [str(d)[:4] + "-" + str(d)[4:6] for d in df["date_ref"]]
    plot_data = []
    for member in all_members:
        ratings = parsed_rating_ind[member]["rating"]
        for i, date in enumerate(plot_dates):
            rating = ratings[i] if i < len(ratings) else None
            if rating is not None:
                plot_data.append({
                    "Date": date,
                    "Member": member,
                    "Rating": rating,
                    "Rating_num": rating_map.get(rating, None)
                })

    # Add group base rating (dashed line)
    for i, date in enumerate(plot_dates):
        group_rating = df["rating_gpe"].iloc[i]
        plot_data.append({
            "Date": date,
            "Member": "Group (Base)",
            "Rating": group_rating,
            "Rating_num": rating_map.get(group_rating, None)
        })

    # Add group override rating (black line)
    for i, date in enumerate(plot_dates):
        group_ovrd_rating = df["rating_ovrd"].iloc[i]
        plot_data.append({
            "Date": date,
            "Member": "Group (Override)",
            "Rating": group_ovrd_rating,
            "Rating_num": rating_map.get(group_ovrd_rating, None)
        })

    plot_df = pd.DataFrame(plot_data)

    # Interactive member selection
    members_to_plot = st.multiselect(
        "Select members to plot",
        options=all_members + ["Group (Override)", "Group (Base)"],
        default=["Group (Override)", "Group (Base)"]  # Both group lines selected by default
    )

    filtered_df = plot_df[plot_df["Member"].isin(members_to_plot)]

    # Plotly line chart
    fig = px.line(
        filtered_df,
        x="Date",
        y="Rating_num",
        color="Member",
        markers=True,
        line_shape=line_shape_value,
        category_orders={
            "Date": plot_dates[::-1]
        },  # Keep date order descending
        labels={
            "Rating_num": "Rating (numeric)",
            "Date": "Date"
        }
    )

    # Ensure all dates are shown on x-axis
    fig.update_xaxes(
        tickmode='array',
        tickvals=plot_dates,
        ticktext=plot_dates
    )

    # Add dashed grey vertical line for each date
    for x_val in plot_dates:
        fig.add_vline(
            x=x_val,
            line_width=1,
            line_dash="dash",
            line_color="grey",
            opacity=0.5,
            layer="below"
        )

    # Style group lines
    for trace in fig.data:
        if trace.name == "Group (Override)":
            trace.update(
                line=dict(width=4, color="black", dash="solid"),
                marker=dict(size=10, symbol="circle", color="black")
            )
        elif trace.name == "Group (Base)":
            trace.update(
                line=dict(width=3, color="black", dash="dash"),
                marker=dict(size=10, symbol="circle", color="black")
            )
        else:
            trace.update(marker=dict(size=7, symbol="circle"))

    # Set y-axis to show rating labels
    inv_rating_map = {v: k for k, v in rating_map.items()}
    fig.update_yaxes(
        tickmode='array',
        tickvals=list(inv_rating_map.keys()),
        ticktext=[inv_rating_map[v] for v in inv_rating_map.keys()],
        autorange="reversed"  # Higher ratings (lower number) at top
    )
    fig.update_layout(
        legend_title_text="Member",
        yaxis_title="Rating",
        xaxis_title="Date",
        height=500
    )

    st.plotly_chart(fig, use_container_width=True)

tab1, tab2, tab3 = st.tabs(["Tab 1", "Tab 2", "Tab 3"])

with tab1:
    st.write("Content for Tab 1")


with tab2:
    df = pd.DataFrame(
        {
            "name": ["Roadmap", "Extras", "Issues"],
            "url": ["https://roadmap.streamlit.app", "https://extras.streamlit.app", "https://issues.streamlit.app"],
            "stars": [random.randint(0, 1000) for _ in range(3)],
            "views_history": [[random.randint(0, 18) for _ in range(12)] for _ in range(3)],
        }
    )
    # st.dataframe(df)
    st.dataframe(
        df,
        column_config={
            "name": "App name",
            "stars": st.column_config.NumberColumn(
                "Github Stars",
                help="Number of stars on GitHub",
                format="%d ⭐",
            ),
            "url": st.column_config.LinkColumn("App URL"),
            "views_history": st.column_config.LineChartColumn(
                "Views (past 30 days)", y_min=0, y_max=18
            ),
        },
        hide_index=True,
    )

with tab3:
    st.write("Content for Tab 3")
    dataframe = pd.DataFrame(
        np.random.randn(10, 20),
        columns=('col %d' % i for i in range(20)))

    st.dataframe(dataframe.style.highlight_max(axis=0))
