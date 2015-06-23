echo "=============================================================="
echo "param: \$(train.ark) \$(label)"
echo ""
echo "This script merge label with .ark file for pdnn (big file)"
echo ".ark format:"
echo "num_row num_col"
echo "sample_1 0.1 0.2 0.3 20"
echo "sample_2 0.1 0.2 0.5 13"
echo ""
echo "label format:"
echo "20"
echo "13"
echo "=============================================================="

data=$(echo $1 | cut -f1 -d.)
label=$2

echo "working..."

dim="$(wc -l $data.ark | awk '{print $(1)}') $(head -n 1 $data.ark | awk -F' '  '{print NF-1}' /dev/stdin)"

paste -d' ' $data.ark $label > $data\_merge.ark
sed -i "1 i$dim" $data\_merge.ark

echo "Check file - $data\_merge.ark"
