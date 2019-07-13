# R Scripts
Couple of handy R Scripts that I use in a daily basis for Scientific Research

## List of Scripts
* Bibliometrix
	* Co-citation Matrix Generator
* Bootstrapping
* Correlation
* Dummyfication
* Factor/Principal Components Analysis
* ggplot2 - Beautiful APA Graphics
* Dataset Import and General Wrangling
* Linear Regression Assumptions
* Polynomials
* Random Sample Splitting
* Recoding Variables
* Standardizing Variables
* Summarize Data
* Stargazer - Beautiful APA Tables
* KMO & Communalities
	* KMO Function - Calculates the Kayser-Meyer-Olkin of not positive definite matrix by employing the Moore-Penrose inverse (*pseudoinverse*). Taken from [StackOverflow](https://stackoverflow.com/questions/12114440/how-do-i-export-a-sorted-factor-loading-table). Results:
		- ```results``` ---list with: Overall KMO, Individual KMO, Anti-image Correlation and Covariance Matrices, and Test Results 
	* KMO Optimal Solution - Uses KMO Function to generate a final solution with all the *individual KMO > 0.5* in a dataframe and them returns a dataframe. Results: 
		- ```df``` ---a dataframe of the final solution
		- ```removed``` ---a list with the variables names that have been removed sorted by first removal to last
		- ```results``` ---results from ```KMO Function```
	* Communalities Optimal Solution - Uses the ```principal``` function from ```psych``` R package to generate a final solution with all the *individual communality > 0.5* in a dataframe and them returns a dataframe.
		- arguments: ```nfactors``` and ```rotate```
		- results: 
			- ```df``` ---a dataframe of the final solution
			- ```removed``` ---a list with the variables names that have been removed sorted by first removal to last
			- ```loadings``` ---the result from ```printLoadings``` function
			- ```results``` ---results from ```principal``` function from ```psych``` R package
	* printLoadings - Function to get a rotated component matrix from a factor analysis in ```psych``` R package while sorting and cutoff. Taken from: [StackOverflow](https://stackoverflow.com/questions/12114440/how-do-i-export-a-sorted-factor-loading-table)
	* How Many Factors - Function to determine how many factors to retain based on:
		- ```Eigenvalues```
		- ```Parallel Analysis```
		- ```Optimal Coordinates```
		- ```Acceleration Factor```
* Text Mining
	* PDF text mining with with ```pdftools```
	* Topic Modeling
		* Text Pre-processing with ```tm```: *Stop Words* and *Stemming*
		* Text Clustering: *k-means* and *hierarchical* clusters
		* Latent Dirichlet Allocation (LDA) with ```topicmodels```
		* Custom Function to convert ```topicmodels``` LDA output to input to LDA visualization with ```LDAvis```

# Author
Jose Eduardo Storopoli
[e-mail](mailto:thestoropoli@gmail.com)