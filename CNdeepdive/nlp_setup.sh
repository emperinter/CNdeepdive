set -euo pipefail
: ${DEPENDENCY_HOME:=~/.ivy2/cache}

if [ ! -d "$DEPENDENCY_HOME" ]; then
    echo "Install Dependency."
    mkdir -p "$DEPENDENCY_HOME"
    cp -r dependency/* "$DEPENDENCY_HOME"
else
	rm -rf "$DEPENDENCY_HOME"
	mkdir -p "$DEPENDENCY_HOME"
    cp -r dependency/* "$DEPENDENCY_HOME"
fi

echo "Denpendency Already Installed."