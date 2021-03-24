import string
import escapism
import sys

safe_chars = set(string.ascii_lowercase + string.digits)
print(escapism.escape(sys.argv[1], safe=safe_chars, escape_char='-').lower())
