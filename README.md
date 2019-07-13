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
	* KMO Function - Calculates the Kayser-Meyer-Olkin of not positive definite matrix by employing the Moore-Penrose inverse (*pseudoinverse*)
	* KMO Optimal Solution - Uses KMO Function to generate a final solution with all the *individual KMO > 0.5* in a dataframe and them returns a dataframe
	* Communalities Optimal Solution - Uses the ```principal``` function from ```psych``` R package to generate a final solution with all the *individual communality > 0.5* in a dataframe and them returns a dataframe. Don't forget to set the argument ```nfactors```. 
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

# Road map
1. Add *Scree Plot* to function ```Communalities Optimal Solution```
	- Either before the *variable grinder* and after
	- Add the different analysis (*elbow*, *acceleration* and *parallel*) from function ```Factor/Principal Components Analysis```
	- Show *percentage of explained variance* by each component
		- Also don't forget to add *cumulative explained variance*
2. Add *Rotated Component Solution*  to function ```Communalities Optimal Solution```
	- Using arguments (*varimax*, *oblimin*, etc.)
	- Displaying the matrix sorted by sized and suppressing loadings below 0.4