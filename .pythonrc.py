# coding=utf-8
import sys, platform
implementation = platform.python_implementation()

sys.ps1 = '%s >>> ' % implementation
sys.ps2 = '...  '

# im too lazy to import some of this stuff all the time
import math
from datetime import datetime

# wrap in try blocks because they may or may not be installed
try:
    import numpy as np
except ModuleNotFoundError:
    pass

try:
    from matplotlib import pyplot as plt
except ModuleNotFoundError:
    pass

try:
    import pandas as pd
except ModuleNotFoundError:
    pass

try:
    import fuck
except ModuleNotFoundError:
    pass

