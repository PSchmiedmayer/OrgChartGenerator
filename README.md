# OrgChart Generator

Launch the OrgChart Generator and select a path using the "Select the OrgChart path". You can export the OrgChart using the "Export OrgChart as PDF" button.

## Using the Command line arguments

You can start the OrgChart generator using the `open` command and the command line arguments:
```
open -a OrgChart\ Generator.app --args $PATH
```

The full list of command line arguments:
```
USAGE: org-chart-arguments <path> [--org-chart-name <org-chart-name>] [--image-size <image-size>] [--compression-rate <compression-rate>] [--enable-crop-faces] [--disable-crop-faces] [--autogenerate] [--no-autogenerate]

ARGUMENTS:
  <path>                  The root folder of the directory structure that
                          should be used to generate the OrgChart 

OPTIONS:
  -o, --org-chart-name <org-chart-name>
                          The name of the OrgChart PDF that should be
                          generated. (default: OrgChart)
  -i, --image-size <image-size>
                          The size of the quadratic images in the OrgChart
                          should be cropped at. (default: 500)
  -c, --compression-rate <compression-rate>
                          The compresssion rate (1-100) that should be applied
                          to the JEPG images that are rendered in the OrgChart.
                          (default: 0.6)
  --enable-crop-faces/--disable-crop-faces
                          Crop the images of the members of the OrgChart so
                          thier faces are centered (default: true)
  --autogenerate/--no-autogenerate
                          Autogenerate the OrgChart without user interaction
                          needed and exit the application when the PDF was
                          exported (default: true)
  -h, --help              Show help information.
```