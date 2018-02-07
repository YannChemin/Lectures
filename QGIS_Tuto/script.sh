#!/bin/bash
# Noms des variables de cartes
dem=elevation.10m
r=roads
s=streams
#Set resolution and extents from elevation.10m
d.region raster=$dem
# buffer cours d'eau et routes
_bs=bstreams500
_br=broads500
# reclassement des buffer cours d'eau et routes
_rbs=rbstreams500
_rbr=rbroads500
#--------------------------------------------------
# Presentation generale: Debut Affichage 0
#--------------------------------------------------
d.mon start=wx0
d.erase color=grey
d.rast map=$dem
sleep 1
d.vect map=$r color=brown
sleep 1
d.vect map=$s color=blue
sleep 1
d.barscale bcolor=white tcolor=black at=30.0,95.0
sleep 2
#--------------------------------------------------
# Creation de buffer: Debut Affichage 1
#--------------------------------------------------
d.mon start=wx1
d.mon select=wx1
d.erase color=grey
r.buffer input=$s output=$_bs distances=500
 units=meters --overwrite
r.null map=$_bs null=0
d.rast map=$_bs
d.vect map=$s color=blue
d.barscale bcolor=white tcolor=black at=30.0,95.0
r.buffer input=$r output=$_br distances=500
 units=meters --overwrite
r.null map=$_br null=0
d.rast map=$_br
d.vect map=$s color=blue
d.barscale bcolor=white tcolor=black at=30.0,95.0
#--------------------------------------------------
# Reclassification: Debut Affichage 2
#--------------------------------------------------
d.mon start=wx2
d.mon select=wx2
d.erase color=grey
echo "...Reclassification..."
r.mapcalc expression="$_rbs=if($_bs==2,1,0)"
r.mapcalc expression="s_sl=if($_rbs==1,if(slope<=5,2,5),0)"
r.mapcalc expression="$_rbr=float(if($_br==2,-5.0,0))"
r.mapcalc expression="for=if(vegcover==3,4,0)"
r.mapcalc expression="for1=if(vegcover==5,1,0)"
r.mapcalc expression="exp1=if(aspect<45.0 || aspect>314.0 &&
 aspect != 0.0,1,0)"
r.mapcalc expression="exp2=if(aspect<225.0 && aspect>135.
 0,1,0)"
r.mapcalc expression="exp3=if(aspect<=135.0 && aspect>=45.0,
 3,0)"
r.mapcalc expression="elev1=if($dem<1400 && $dem>1200,2,0)"
r.mapcalc expression="elev2=if($dem<1600 && $dem>=1400,4,0)"
r.mapcalc expression="elev3=if($dem>=1600,2,0)"
#--------------------------------------------------
r.buffer input=$r output=br100 distances=100
 units=meters --overwrite
r.null map=br100 null=0
r.mapcalc expression="add=float(s_sl+$_rbr+for+for1+
 exp1+exp2+exp3+elev1+elev2+elev3)"
r.mapcalc expression="clas=if(add{>9,1,null())"
r.mapcalc expression="class=if(clas==1&&br100==0,1,null())"
echo "Reclassification...Fin."
d.rast map="$_rbs"
sleep 1
d.rast map="s_sl"
d.rast map="$_rbr"
d.rast map="for"
d.rast map="for1"
d.rast map="exp1"
d.rast map="exp2"
d.rast map="exp3"
d.rast map="elev1"
d.rast map="elev2"
d.rast map="elev3"
d.rast map="br100"
sleep 1
#r.colors color=grey map="add"
d.rast map="add"
sleep 1
d.rast map="class"
sleep 1
#d.erase
d.vect map="$s" color=blue
d.vect map="$r" color=brown
d.barscale bcolor=white tcolor=black at=30.0,95.0
sleep 5
g.remove
rast="$_rbs,s_sl,$_rbr,for,for1"
g.remove
rast="exp1,exp2,exp3,elev1"
g.remove
rast="elev2,elev3,br100,add"
g.remove rast="$_bs,$_br,clas"
sleep 1
echo ""
echo "fin"
sleep 1
#--------------------------------------------------
# Mettre en bloc: Debut Affichage 3
#--------------------------------------------------
d.mon start=wx3
d.mon select=wx3
d.erase color=grey
g.remove rast=clump.clump._rclumpnew
r.clump input=class output=clump --overwrite
r.colors color=gyr map="clump"
d.rast map="clump"
sleep 1
r.reclass.area input=clump greater=50
 output=rclumpnew --overwrite
r.colors color=gyr map="rclumpnew"
d.erase color=white
d.rast map="rclumpnew"
sleep 1
d.vect map="streams" color=blue
d.vect map="roads" color=brown
d.barscale bcolor=white tcolor=black at=30.0,95.0
sleep 1
g.remove rast="clump,class"
#--------------------------------------------------
# R2V et Export: Debut Affichage 4
#--------------------------------------------------
d.mon start=wx4
d.mon select=wx4
d.erase color=white
r.to.vect -s input=rclumpnew output=rclump
 feature=area --overwrite
d.vect -c map=rclump type=area color=black
d.vect map="streams" color=blue
d.vect map="roads" color=brown
d.barscale bcolor=white tcolor=black at=30.0,95.0
sleep 1
v.out.ogr input=rclump type=area dsn=QGISDATA
 layer=1 format=ESRI_Shapefile --overwrite
g.remove rast="rclumpnew"
g.remove vect="rclump"
d.mon stop=wx4
d.mon stop=wx3
d.mon stop=wx2
d.mon stop=wx1
d.mon stop=wx0
