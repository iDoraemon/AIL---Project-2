# AIL---Project-2

#Q1. Load the feature table.

Using color average, dataset is exported to "data.csv" file. The format looks like this:

		f1	f2	f3	category
	x
	...
	
In detail, the table consists of:

a) 4 collumns:
- f1, f2, f3: red, green, blue, respectively.
- category: one of "coast", "forest", "highway", "insidecity", "mountain", "opencountry", "street", "tallbuilding".

b) 2689 collumns:
- correspond to 2688 images and 1 header row.

(For in-depth information, refer .CSV file)

In this project I choose color averaging since I used color histogram last time. It generated a 2688-dimenisional vector, hence the processing time is rather large, but the result is not bad in anyways.
This time, with just color averaging with RGB, the data is much smaller in scale. Perfomance is indeed faster. However, I don't expect precise result.

#Q2. Design a classifier to give a tag for each image. 

- Use Logistic Regression.
- Error:
 	+) In training: 0.657112527
	+) In testing: 	0.676616915

The error is high. As I said, we can't expect good result from a poor feature table.

#Q3. Produce the output.

After running the code, "output.html" is generated, containing the result.
