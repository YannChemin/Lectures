# For image processing
from math import *
import numpy

from osgeo import gdalnumeric
from osgeo import gdal

from osgeo.gdal_array import *
from osgeo.gdalconst import *

# File names 
F = [ ]
F.append('/home/nettop/subset/L71141055_05520060123_B30.TIF')
F.append('/home/nettop/subset/L71141055_05520060123_B40.TIF')

# Output raster format to be used
driver = gdal.GetDriverByName( 'ENVI' )

# Output projection to be used
tmp = gdal.Open( F[0] )
geoT = tmp.GetGeoTransform()
proJ = tmp.GetProjection()
del tmp

# Load Files in RAM
b3 = LoadFile( F[0] )
b4 = LoadFile( F[1] )

# Define Algorithm function
def ndvi(red,nir):
	return 100*(1+(nir-red)/(nir+red+0.01))

# Process
vi = ndvi(b3,b4)

# Open vi array
out = OpenArray( vi )

#Set projection and transform
out.SetGeoTransform( geoT )
out.SetProjection( proJ )

#Copy raster format style and add data
driver.CreateCopy( '/home/nettop/subset/ndvi', out)

#Clean memory
del out, vi
