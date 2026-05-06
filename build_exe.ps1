$ErrorActionPreference = "Stop"

python -m pip install -r requirements-build.txt
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

python -m PyInstaller --noconfirm --clean --windowed --onefile --name "UpstreamKit" api_relay_gui.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host ""
Write-Host "Build complete: dist\UpstreamKit.exe"
