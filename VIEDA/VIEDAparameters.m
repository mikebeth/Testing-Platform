
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Vortex Island Estimation of Distribution Algorithm++                %
%       Dr. Yoan Martínez-López, Camaguey University, Cuba              %
%       Eng. Miguel Bethencourt, Camaguey University, Cuba              %
%       Dt. Julio Madera, Camaguey University, Cuba                     %
%       Dr. Ansel Rodriguez, CICESE, Mexico                             %
%       Dr. Wenlei Bai, the Oracle Energy and Water, Oracle America Inc.,% 
%           Austin, TX,USA                                               % 
%       Haoxiang Qin,  the School of Software Engineering,                % 
%          South China University of Technology, Guangzhou 510006, China  % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ref:
% Do?an, B., & Ölmez, T. (2015). A new metaheuristic for numerical function optimization: Vortex Search algorithm. Information Sciences, 293, 125-145.
% Madera, J., Alba, E., & Ochoa, A. (2006). A parallel island model for estimation of distribution algorithms. In Towards a new evolutionary computation (pp. 159-186). Springer, Berlin, Heidelberg.
% Martínez-López, Y., Madera, J., Rodríguez-González, A. Y., & Barigye, S. (2019). Cellular estimation Gaussian algorithm for continuous domain. Journal of Intelligent & Fuzzy Systems, 36(5), 4957-4967.
% Martínez-López, Y., Rodríguez-González, A. Y., Quintana, J. M., Moya, A., Morgado, B., & Mayedo, M. B. (2019, July). CUMDANCauchy-C1: a cellular EDA designed to solve the energy resource management problem under uncertainty. In Proceedings of the Genetic and Evolutionary Computation Conference Companion (pp. 13-14).
% Martínez-López, Y., Rodríguez-González, A. Y., Quintana, J. M., Mayedo, M. B., Moya, A., & Santiago, O. M. (2020, July). Applying some EDAs and hybrid variants to the ERM problem under uncertainty. In Proceedings of the 2020 Genetic and Evolutionary Computation Conference Companion (pp. 1-2).
% Martínez-López, Y., Rodríguez-González, A. Y., Madera, J., Mayedo, M. B., & Lezama, F. (2021). Cellular estimation of distribution algorithm designed to solve the energy resource management problem under uncertainty. Engineering Applications of Artificial Intelligence, 101, 104231.
% Rodríguez-González, A. Y., Lezama, F., Martínez-López, Y., Madera, J., Soares, J., & Vale, Z. (2022). WCCI/GECCO 2020 Competition on Evolutionary Computation in the Energy Domain: An overview from the winner perspective. Applied Soft Computing, 109162.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% email: cybervalient@gmail.com, betamiguel00@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


VIEDAParameters = struct();
VIEDAParameters.I_NP = 50;  % Population size
VIEDAParameters.I_itermax = 1000;  % Maximum number of iterations
VIEDAParameters.low_habitat_limit = [-5, -5];  % Lower bounds for x1 and x2
VIEDAParameters.up_habitat_limit = [10, 10];  % Upper bounds for x1 and x2
VIEDAParameters.Sub_Pop = 5;  % Number of sub-populations
VIEDAParameters.Sub_Pop_Size = 10;  % Size of each sub-population
VIEDAParameters.Elitist_Selection = 10;  % Number of elite individuals
VIEDAParameters.radius = 0.1;  % Initial radius for local search
VIEDAParameters.w_BB_BC = 0.5;  % Weight for Big Bang-Big Crunch