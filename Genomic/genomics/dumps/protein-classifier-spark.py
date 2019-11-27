from pyspark import SparkConf, SparkContext
from pyspark.sql import SparkSession
from pyspark.mllib.tree import DecisionTree, DecisionTreeModel
from pyspark.mllib.classification import LogisticRegressionWithLBFGS, LogisticRegressionModel
from pyspark.mllib.regression import LabeledPoint
from pyspark.mllib.tree import RandomForest, RandomForestModel
from pyspark.mllib.util import MLUtils
from pyspark.mllib.evaluation import MulticlassMetrics
from pyspark.mllib.regression import LabeledPoint

from pyspark.ml import Pipeline
from pyspark.ml.classification import GBTClassifier
from pyspark.ml.feature import StringIndexer, VectorIndexer
from pyspark.ml.evaluation import MulticlassClassificationEvaluator

import sys

# conf = SparkConf().setMaster("local").setAppName("ProtienClassifier")
# sc = SparkContext(conf = conf)

spark = SparkSession.builder.appName('protien-classifier').getOrCreate()
rdd = spark.read.csv("final_data/protien-sequences.csv", header=True).rdd
#source_file = sc.textFile('file:///home/cloudera/protien-sequences.csv')

#rdd = sc.textFile("final_data/protien-sequences.csv")# .map(lambda line: line.split(","))
libsvm_data = rdd.map(lambda line: LabeledPoint(line[24],[line[0],line[1],
                                                    line[2],line[3],
                                                    line[4],line[5],
                                                    line[6],line[7],
                                                    line[8],line[9],
                                                    line[10],line[11],
                                                    line[12],line[13],
                                                    line[14],line[15],
                                                    line[17],line[19],
                                                    line[20],line[21],
                                                    line[22],line[23]
                                                   ]))

(trainingData, testData) = libsvm_data.randomSplit([0.7, 0.3])
print(trainingData.take(2))
print(testData.take(2))

train_size = trainingData.count()
print(train_size)
test_size = testData.count()
print(test_size)

# Run training algorithm to build the model
model = LogisticRegressionWithLBFGS.train(trainingData, numClasses=3)

# Compute raw scores on the test set
predictionAndLabels = testData.map(lambda lp: (float(model.predict(lp.features)), lp.label))

# Instantiate metrics object
metrics = MulticlassMetrics(predictionAndLabels)

# Overall statistics
precision = metrics.precision()
recall = metrics.recall()
f1Score = metrics.fMeasure()
print("Summary Stats")
print("Precision = %s" % precision)
print("Recall = %s" % recall)
print("F1 Score = %s" % f1Score)

# Statistics by class
labels = libsvm_data.map(lambda lp: lp.label).distinct().collect()
for label in sorted(labels):
    print("Class %s precision = %s" % (label, metrics.precision(label)))
    print("Class %s recall = %s" % (label, metrics.recall(label)))
    print("Class %s F1 Measure = %s" % (label, metrics.fMeasure(label, beta=1.0)))

# Weighted stats
print("Weighted recall = %s" % metrics.weightedRecall)
print("Weighted precision = %s" % metrics.weightedPrecision)
print("Weighted F(1) Score = %s" % metrics.weightedFMeasure())
print("Weighted F(0.5) Score = %s" % metrics.weightedFMeasure(beta=0.5))
print("Weighted false positive rate = %s" % metrics.weightedFalsePositiveRate)
