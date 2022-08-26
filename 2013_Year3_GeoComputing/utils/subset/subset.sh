ulx=442583
uly=778303
lrx=455341 
lry=760265

cd ..
for file in *.TIF
do
	gdal_translate -projwin $ulx $uly $lrx $lry $file subset/$file
done
