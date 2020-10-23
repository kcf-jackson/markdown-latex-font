Source: [*Excerpt from Ch.7, Introduction to Probability, Statistics, and Random Processes*](https://www.probabilitycourse.com/)  by Hossein Pishro-Nik  
License: [Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License](https://creativecommons.org/licenses/by-nc-nd/3.0/deed.en_US)

## Chapter 7: Limit Theorems and Convergence of Random Variables

In this chapter, we will discuss limit theorems and convergence modes for random variables. Limit theorems are among the most fundamental results in probability theory. We will discuss two important limit theorems in Section 7.1: the law of large numbers (LLN) and the central limit theorem (CLT). We will also talk about the importance of these theorems as applied in practice. In Section 7.2, we will discuss the convergence of sequences of random variables.

### 7.1 Limit Theorems

In this section, we will discuss two important theorems in probability, the law of large numbers (LLN) and the central limit theorem (CLT). The LLN basically states that the average of a large number of i.i.d. random variables converges to the expected value. The CLT states that, under some conditions, the sum of a large number of random variables has an approximately normal distribution.

#### Law of Large Numbers

The **law of large numbers** has a very central role in probability and statistics. It states that if you repeat an experiment independently a large number of times and average the result, what you obtain should be close to the expected value. There are two main versions of the law of large numbers. They are called the **weak** and **strong** laws of the large numbers. The difference between them is mostly theoretical. In this section, we state and prove the weak law of large numbers (WLLN). The strong law of large numbers is discussed in Section 7.2. Before discussing the WLLN, let us define the sample mean.

**Definition 7.1.** For i.i.d. random variables $X_1, X_2, ..., X_n$, the **sample mean**, denoted by $\overline{X}$, is defined as
$$\overline{X} = \dfrac{X_1 + X_2 + ... + X_n}{n}.$$
Another common notation for the sample mean is $M_n$. If the $X_i$'s have CDF $F_X(x)$, we might show the sample mean by $M_n(X)$ to indicate the distribution of the $X_i$'s.

Note that since the $X_i$'s are random variables, the sample mean, $\overline{X}=M_n(X)$, is also a random variable. In particular, we have
$$\begin{aligned}
E[\overline{X}] 
&= \dfrac{EX_1+EX_2+...+EX_n}{n} \quad\text{(by linearity of expectation)}\\\\ 
&= \dfrac{n EX}{n} \quad\text{(since $EX_i=EX$)}\\\\ 
&=EX.
\end{aligned}$$

Also, the variance of $\overline{X}$ is given by

$$\begin{aligned}
Var(\overline{X}) 
&=\dfrac{Var(X_1+X_2+...+X_n)}{n^2}  \quad\text{(since $Var(aX)=a^2Var(X)$)}\\\\
&=\dfrac{Var(X_1)+Var(X_2)+...+Var(X_n)}{n^2}   \quad\text{(since the $X_i$'s are independent)}\\\\
&=\dfrac{n Var(X)}{n^2}    \quad\text{(since $Var(X_i)=Var(X)$)}\\\\
&=\dfrac{Var(X)}{n}.
\end{aligned}$$


Now let us state and prove the **weak law of large numbers (WLLN)**.

#### The weak law of large numbers (WLLN)

Let $X_1, X_2 , ... , X_n$ be i.i.d. random variables with a finite expected value $EX_i = \mu < \infty$. Then, for any $\epsilon>0$,
$\lim_{n\rightarrow\infty} P(|\overline{X} - \mu| \geq \epsilon) = 0$.

#### Proof

The proof of the weak law of large number is easier if we assume $Var(X)=\sigma^2$ is finite. In this case we can use Chebyshev's inequality to write
$$P(|\overline{X} − \mu| \geq \epsilon) \leq \dfrac{Var(\overline{X})}{\epsilon^2} =  \dfrac{Var(X)}{n\epsilon^2}$$
which goes to zero as $n\rightarrow\infty$.
