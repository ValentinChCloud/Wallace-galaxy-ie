import sys
import os
from galaxy_ie_helpers import put
arg1 = sys.argv[1]
print("Que vaut arg1 %s"  % arg1)
put('%s' % arg1, file_type='csv')
