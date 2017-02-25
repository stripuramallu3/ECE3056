add $4, $3, $2
jal label1
add $5, $4, $3
label1: add $6, $3, $4
jal label2
add $7, $6, $3
label2: add $8, $6, $3
jal endlabel
add $9, $8, $3
endlabel: add $10, $8, $3