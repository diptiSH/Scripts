#!/bin/bash
 # this is my first shell script.JGRJJD
levels=(850hPa )
 for l in "${levels[@]}"
     do

  ndays=( 1 2 3 4 5 6 7)

  for j in "${ndays[@]}"
     do
         echo $l

         cdo merge "/iitm2/cccr-res/ramesh/13Station_subset_sequence/moisture_flux_daily/SOM1/""$l""/combine-FogDay-""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/SOM1/""$l""/SOM1-""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/9March/SOM1/""$l""/combine-FogDay-""$j""_ERA_1.5_""$l"".nc"

              cdo merge "/iitm2/cccr-res/ramesh/13Station_subset_sequence/moisture_flux_daily/SOM1/""$l""/combine-CompFogDay-""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/SOM1/""$l""/CompSOM1-""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/9March/SOM1/""$l""/combine-CompFogDay-""$j""_ERA_1.5_""$l"".nc"
        
   
            cdo merge "/iitm2/cccr-res/ramesh/13Station_subset_sequence/moisture_flux_daily/SOM1/""$l""/combine-AnomFogDay-""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/SOM1/""$l""/AnomSOM1-""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/9March/SOM1/""$l""/combine-AnomFogDay-""$j""_ERA_1.5_""$l"".nc"  
   
  done



ndays=( 0 1 2 3 4 5 6 7)

 for j in "${ndays[@]}"
     do
          
     cdo merge "/iitm2/cccr-res/ramesh/13Station_subset_sequence/moisture_flux_daily/SOM1/""$l""/combine-FogDay+""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/SOM1/""$l""/SOM1+""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/9March/SOM1/""$l""/combine-FogDay+""$j""_ERA_1.5_""$l"".nc"

              cdo merge "/iitm2/cccr-res/ramesh/13Station_subset_sequence/moisture_flux_daily/SOM1/""$l""/combine-CompFogDay+""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/SOM1/""$l""/CompSOM1+""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/9March/SOM1/""$l""/combine-CompFogDay+""$j""_ERA_1.5_""$l"".nc"
        
   
            cdo merge "/iitm2/cccr-res/ramesh/13Station_subset_sequence/moisture_flux_daily/SOM1/""$l""/combine-AnomFogDay+""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/SOM1/""$l""/AnomSOM1+""$j""_ERA_1.5_""$l"".nc" "/iitm2/cccr-res/ramesh/13Station_subset_sequence/9March/SOM1/""$l""/combine-AnomFogDay+""$j""_ERA_1.5_""$l"".nc"
     echo $j
          

done

done



