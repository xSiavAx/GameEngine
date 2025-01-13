
# Troubleshooting
If during app start in console output you can see messages (usually on Linux, perhaps Ubuntu):
> MESA: error: ZINK: failed to choose pdev
> glx: failed to create drisw screen
As workaround, try setup GALLIUM_DRIVER env var to d3d12:
> export GALLIUM_DRIVER=d3d12
