function p = bvnl( dh, dk, r )
%
%  A function for computing bivariate normal probabilities.
%  bvnl calculates the probability that x < dh and y < dk. 
%    parameters  
%      dh 1st upper integration limit
%      dk 2nd upper integration limit
%      r   correlation coefficient
%
%   Author
%       Alan Genz
%       Department of Mathematics
%       Washington State University
%       Pullman, Wa 99164-3113
%       Email : alangenz@wsu.edu
%   This function is based on the method described by 
%        Drezner, Z and G.O. Wesolowsky, (1989),
%        On the computation of the bivariate normal inegral,
%        Journal of Statist. Comput. Simul. 35, pp. 101-107,
%    with major modifications for double precision, for |r| close to 1,
%    and for matlab by Alan Genz - last modifications 7/98.
%
      p = bvnu( -dh, -dk, r );
 