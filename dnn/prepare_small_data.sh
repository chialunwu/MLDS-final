echo "=============================================================="
echo "param: \$(train.ark) \$(label)"
echo ""
echo "This script merge label with .ark file for pdnn (small file)"
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

paste -d' ' $data.ark $label > $data\_merge.ark

echo "Check file - $data\_merge.ark"
