#!/bin/bash

files=(
    "types.go"
    "vulkan.go"
    "const.go"
    "cgo_helpers.go"
)

sed -i -E 's/PipelineCacheHeaderVersionOne/PipelineCacheHeaderVersion1/g' "const.go"
sed -i -E 's/True = uint32\(1\)/True = 1/g' "const.go"
sed -i -E 's/False = uint32\(0\)/False = 0/g' "const.go"

for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "Processing file: $file"

        # Replace broken naming from struct_(XXX)_T to XXX
        sed -i -E -e 's/struct_([a-zA-Z0-9_]+)_T/\1/g' "$file"

        # Replace SurfaceKHR (and other to Surface) and exclude C structs from replacements.
        sed -i -E 's/(\*|\[\]|\s+)(Surface|Swapchain|Display|DisplayMode|DebugReportCallback|VideoSessionParameters|VideoSession|ValidationCache)(KHR|EXT)/\1\2/g' "$file"

        # use for MacOS
        # sed -i '' -E -e 's/struct_([a-zA-Z0-9_]+)_T/\1/g' "$file"
        # sed -i '' -E 's/(\*|\[\]|\s+)(Surface|Swapchain|Display|DisplayMode|DebugReportCallback|VideoSessionParameters|VideoSession|ValidationCache)(KHR|EXT)/\1\2/g' "$file"

    else
        echo "File not found: $file"
    fi
done

echo "Done."