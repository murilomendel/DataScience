# Regular Expressions(Regex)
import re

# MAtching phone number pattern
phoneNumRegex = re.compile(r'(\(\d\d\d\))-(\d\d\d-\d\d\d)')
mo = phoneNumRegex.search('My number is (415)-555-4242.')
print('Phone number found: ' + mo.group())
areaCode, mainNumber = mo.groups()
print(areaCode)
print(mainNumber)

# Matching multiple groups with Pipe(|)
heroRegex = re.compile(r'Batman|Tina Fey')
mo1 = heroRegex.search('Batman and Tina Fey')
mo1.group()
mo2 = heroRegex.search('Tina Fey and Batman')
mo2.group()


batRegex = re.compile(r'Bat(man|mobile|capter|bat)')
mo = batRegex.search('Batmobile lost a wheel')
mo.group()
mo.group(1)

# Optional Matching with Question Mark
batRegex = re.compile(r'Bat(wo)?man')
mo1 = batRegex.search('The Adventures of Batman')
mo1.group()
mo2 = batRegex.search('The Adventures of Batwoman')
mo2.group()

# Matching zero or more with star
batRegex = re.compile(r'Bat(wo)*man')
mo1 = batRegex.search('The Adventures of Batman')
mo1.group()
mo2 = batRegex.search('The Adventures of Batwoman')
mo2.group()
mo3 = batRegex.search('The Adventures of Batwowowowowoman')
mo3.group()

# Matching one or more with plus
batRegex = re.compile(r'Bat(wo)+man')
mo1 = batRegex.search('The Adventures of Batman')
mo1 == None
mo2 = batRegex.search('The Adventures of Batwoman')
mo2.group()
mo3 = batRegex.search('The Adventures of Batwowowowowoman')
mo3.group()

# Matching Specific Repetitions with Braces
haRegex = re.compile(r'(Ha){3}')
mo1 = haRegex.search('HaHaHa')
mo1.group()

mo2 = haRegex.search('Ha')
mo2 == None

# Greedy and Non-greedy Matching
greedyHaRegex = re.compile(r'(Ha){3,5}')
mo1 = greedyHaRegex.search('HaHaHaHaHa')
mo1.group()

nongreedyHaRegex = re.compile(r'(Ha){3,5}?')
mo2 = nongreedyHaRegex.search('HaHaHaHaHa')
mo2.group()

# The findall() method
# search(): return a match object of the first matched text in the searched string
phoneNumRegex = re.compile(r'\d\d\d-\d\d\d-\d\d\d\d') # No groups
mo = phoneNumRegex.search('Cell: 415-555-9999 Work: 212-555-0000')
mo.group()

# findall(): return the string of every match in the searched string
phoneNumRegex.findall('Cell: 415-555-9999 Work: 212-555-0000')
phoneNumRegex = re.compile(r'(\d\d\d)-(\d\d\d)-(\d\d\d\d)') # Three groups
phoneNumRegex.findall('Cell: 415-555-9999 Work: 212-555-0000')

# Character Classes
# \d - Any numeric digit from 0 to 9
# \D - Any character that IS NOT a digit from 0 to 9
# \w - Any letter, numeric digit or the underscore character
# \W - Any character that IS NOT letter, numeric digit or the underscore character
# \s - Any space, tab or newline character
# \S - Any character that IS NOT a space, tab or newline character

xmasRegex = re.compile(r'\d+\s\w+')
xmasRegex.findall('12 drummers, 11 pipers, 10 lords, 9 ladies, 8 maids, 7 swans, 6geese, 4 birds, 3 hens, 2 doves, 1 partridge')

# Making your own character classes
vowelRegex = re.compile(r'[aeiouAEIOU]')
vowelRegex = re.compile(r'[^aeiouAEIOU]') # Negative character class
vowelRegex.findall("Robocop eats baby food. BABY FOOD")

# Caret and Dollar sign Characters
beginsWithHello = re.compile(r'^Hello')
beginsWithHello.search("Hello, world!")
beginsWithHello.search('He said hello') == None

endsWithNumber = re.compile(r'\d$')
endsWithNumber.search('Your number is 42')
endsWithNumber.search ('Your number is fourty two') == None

wholeStringMatch = re.compile(r'^\d+$') # Entire strig must match to the pattern 
wholeStringMatch.search('1234567890')
wholeStringMatch.search('12345xyz67890') == None
wholeStringMatch.search('12  34567890') == None

# The Wildcard character
atRegex = re.compile(r'.at')
atRegex.findall('The cat in the hats sat on the flat mat.')

# Matching everything with Dot-Star
nameRegex = re.compile(r'First Name: (.*) Last Name: (.*)')
mo = nameRegex.search('First Name: Al Last Name: Sweigart')
mo.group(1)
mo.group(2)

nongreedyRegex = re.compile(r'<.*?>')
mo = nongreedyRegex.search('<to serve man> for dinner.>')
mo.group()

greedyRegex = re.compile(r'<.*>')
mo = greedyRegex.search('<to serve man> for dinner.>')
mo.group()

# Matching Newlines with the Dot Character
# . (dot) character will match everything except a new line
# Passing re.DOTALL as the second argument to the re.compile(),
# you can make the . character match all characters, including the new line character.
noNewLineRegex = re.compile(r'.*')
noNewLineRegex.search('Serve the public trust.\nProtect the innocent.\nUphold the law.').group()

newLineRegex = re.compile(r'.*', re.DOTALL)
newLineRegex.search('Serve the public trust.\nProtect the innocent.\nUphold the law.').group()

# Case-Insensitive Matching
regex1 = re.compile('Robocop')
regex2 = re.compile('ROBOCOP')
regex3 = re.compile('robOcop')
regex4 = re.compile('RobocOp')

robocop = re.compile(r'robocop', re.I)
robocop.search('RoboCop is part man, part machine, all cop.').group()
robocop.search('ROBOCOP is part man, part machine, all cop.').group()
robocop.search('Al, why does yout programming book talk about robocop so much?').group()

# Substituing Strings with the sub() Method
nameRegex = re.compile(r'Agent \w+')
nameRegex.sub('CENSORED', 'Agent Alice gave the secret documents to Agent Bob')

agentNamesRegex = re.compile(r'Agent (\w)\w*')
agentNamesRegex.sub(r'\1****', 'Agent Alice told Agent Carol that Agent Eve knew Agent Bob was a double agent.')

# Managing Complex Regex
# tell re.compile to ignore whitespace and commets inside the regular expression
phoneRegex = re.compile(r'((\d{3}|\(\d{3}\))?(\s|-|\.)?\d{3}(\s|-|\.)\d{4}(\s*(ext|x|ext.)\s*\d{2,5})?)')

# Organized expression with ''' (thriple-quotes)
# Verbose ignore the spaces and comments writen on the regular expression 
phoneRegex = re.compile(r'''((\d{3}|\(\d{3}\))?       # area code
                        (\s|-|\.)?                    # separator 
                        \d{3}                         # first 3 digits
                        (\s|-|\.)                     # separator
                        \d{4}                         # last 4 digits
                        (\s*(ext|x|ext.)\s*\d{2,5})?  # extension
                        )''', re.VERBOSE)

# Combining re.IGNORECASE, re.DOTALL and re.VERBOSE
# Using bitwise operators: http://nostarch.com/automatestuff2/
someRegexValue = re.compile('foo', re.IGNORECASE | re.DOTALL)
someRegexValue = re.compile('foo', re.IGNORECASE | re.DOTALL | re.VERBOSE)
