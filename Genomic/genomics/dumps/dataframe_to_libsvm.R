# Ref : https://vatsalbits.wordpress.com/2016/01/13/csv-to-libsvm/

# download e1071 library if not available
if (!require(e1071)) {install.packages("e1071")}

# download sparseM library if not available
if (!require(SparseM)) {install.packages("SparseM")}

# load the libraries
library(e1071)
library(SparseM)

# load the csv dataset into memory
data <- read.csv('final_data/protien-sequences.csv')

# take the numeric columns are format as matrix
x <- as.matrix(data[,c('A', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'Y', 'gravy', 'weight')])
# assign labels to vector y
y <- data[,'type_numeric']

# convert input columns to sparse matrix
x_matrix <- as.matrix.csr(x)

# write output to libsvm format
write.matrix.csr(x_matrix, y=y, file="data/protien-sequences-libsvm.txt")
