echo "=============================================================="
echo "param: \$(train.ark) \$(label)"
echo ""
echo "This script merge label with .ark file for pdnn (big file)"
echo ".ark format:"
echo "sample_1 0.1 0.2 0.3"
echo "sample_2 0.1 0.2 0.5"
echo ""
echo "label format:"
echo "20"
echo "13"
echo "=============================================================="

data=$(echo $1 | cut -f1 -d.)
label=$2

echo "Merging..."
if [ ! -z "$label" -a "$label"!=" " ]; then
        echo "Assume this is training data"
	paste -d' ' $data.ark $label > $data\_merge.ark || exit 1
else
        echo "Assume this is testing data"
	sed -e 's/$/ 0/' $data.ark > $data\_merge.ark || exit 1
fi

echo "Add dimension info to the first line"
dim="$(wc -l $data.ark | awk '{print $(1)}') $(head -n 1 $data.ark | awk -F' '  '{print NF-1}' /dev/stdin)" || exit 1
sed -i "1 i$dim" $data\_merge.ark || exit 1

rm -f $data.ark
echo "Done. Please check $data\_merge.ark"
