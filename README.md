Background
==========

On the 4th of June, 2016, an East Coast Low [1] impacted New South
Wales, causing wave overtopping and severe erosion in several areas.
This event was a very intense, low pressure system that brought over
100mm of rainfall in one hour at places along the east coast NSW.
Widespread rainfall totals exceeded 250mm along most of the NSW coast,
leading to 21 catchments experiencing flooding and nearly all of the
east-flowing rivers being affected. Periods of sustained gale force
winds (over 63km/h) were recorded along the coast, and the Sydney
Harbour experienced wind gusts of 116km/h. This intense event also
coincided with tides near the Highest Astronomical Tide, combined with
pressure-induced sea-level anomalies, and large north-easterly waves,
which resulted in local inundation of low-lying areas and widespread
coastal erosion (See [Louis et.
al.](https://www.mhl.nsw.gov.au/data/realtime/wave/docs//2016NSWCoastalConferenceLouisCourieletal_Final.pdf)
for more information).

This analysis investigates the role that storm waves may have played in
the damaging event by extracting data from the CAWCR Wave Hindcast [2]
on the CSIRO THREDDS server.

Obtaining the data
==================

The wave data required for this analysis was the ww3.aus\_4m.201606.nc
file and can be accessed from THREDDS [in this
collection](http://data-cbr.csiro.au/thredds/catalog/catch_all/CMAR_CAWCR-Wave_archive/CAWCR_Wave_Hindcast_aggregate/gridded/catalog.html).
To minimise the file size, the ww3.aus\_4m.201606 NetCDF4 file was
subset server-side to only include the following variables:

-   Wave energy flux.
-   Peak wave direction.
-   Significant wave height.
-   Wave directional spread.

The dates and times of the data only included the interval from 0000
hours on the 3rd of June, 2016 to 2300 hours on the 9th of June, 2016,
which covers the period of time of interest.

The data were downloaded programmatically using **R** (v3.5.3) from the
[THREDDS data server NetCDF Subset
Service](http://data-cbr.csiro.au/thredds/ncss/grid/catch_all/CMAR_CAWCR-Wave_archive/CAWCR_Wave_Hindcast_aggregate/gridded/ww3.pac_4m.201901.nc/dataset.html),
and then read into **R** for data processing and creating spatiotemporal
objects for analysis. Both of these steps can be reproduced using the
[R/wave\_data\_download.R](R/wave_data_download.R) and
[R/wave\_data\_import.R](R/post_process.R) files, respectively.

Results
=======

The following results are split into 3 different spatial scales, as
shown in Figure 1, and defined below:

-   The large region covering most of the east coast of Australia. This
    is also the region used in Figure 5 of Louis et. al. (this area is
    defined by the solid black line in Figure 1).
-   A smaller region covering most of the NSW coast of Australia (this
    area is defined by the solid black line in Figure 1).
-   A random location, just off the coast of Sydney (this location is
    defined by the small black dot).

![Figure 1: Map of Australia (lightgrey polygons) showing the 3
different spatial scales in this
analysis.](README_files/figure-markdown_strict/aus_map-1.png)

Large region covering most of the east coast of Australia
---------------------------------------------------------

![Figure 2: Time series plot showing the maximum significant wave height
(top panel), and the maximum wave energy flux (bottom panel), for the
entire region covering most of the east coast of
Australia.](README_files/figure-markdown_strict/large_region_analysis-1.png)

Smaller region covering most of the NSW coastline
-------------------------------------------------

![Figure 3: Time series plot showing the direction from which the peak
of the wave was travelling (black line), and the associated spread
(light grey
ribbon).](README_files/figure-markdown_strict/small_region_analysis-1.png)

[1] [Holland, G. J., Lynch, A. H., & Leslie, L. M. (1987). *Australian
east-coast cyclones. Part I: Synoptic overview and case study. Monthly
Weather Review, 115*(12),
3024-3036.](https://journals.ametsoc.org/doi/10.1175/1520-0493%281987%29115%3C3024%3AAECCPI%3E2.0.CO%3B2)

[2] Durrant, Thomas; Hemer, Mark; Trenham, Claire; Greenslade, Diana
(2013): CAWCR Wave Hindcast 1979-2010. v7. CSIRO. Data Collection.
<a href="https://doi.org/10.4225/08/523168703DCC5" class="uri">https://doi.org/10.4225/08/523168703DCC5</a>
