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
    a = np.random.randn(5, 10)
    import pandas as pd
    d = pd.DataFrame({"a": np.random.randn(10),
                      "b": np.random.randn(10),
                      "c": np.random.randn(10)})
except ImportError:
    pass

try:
    from matplotlib import pyplot as plt
except ImportError:
    pass
