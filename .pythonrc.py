# coding=utf-8
import sys, platform
implementation = platform.python_implementation()

sys.ps1 = '%s >>> ' % implementation
sys.ps2 = '...  '

# im too lazy to import some of this stuff all the time
import math, os, re
from datetime import datetime

# wrap in try blocks because they may or may not be installed
try:
    import numpy as np
except ImportError:
    pass

try:
    from matplotlib import pyplot as plt
except ImportError:
    pass

try:
    import pandas as pd
except ImportError:
    pass

