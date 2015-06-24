echo "=============================================================="
echo "param: \$(train.ark) \$(label)"
echo ""
echo "This script merge label with .ark file for pdnn (small file)"
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

rm -f $data.ark
echo "Done. Please check $data\_merge.ark"
