clear
 
%State space
    A_vec = [1,1.1];
 
    k_min = 3.2;
    k_max = 4.5;
    k_num = 100;
    k_vec = linspace(k_min,k_max,k_num);
 
    [A_grid,k_grid]=meshgrid(A_vec,k_vec)
 
%Parameters
    delta = 0.05;
    alpha = 0.3;
    beta=0.95;

%Initial guess at policy 
    knext_policy = k_grid;
    L_policy = 0.7*ones(size(k_grid));

%Four calibrations
    sigma_vec = [2;0.05;1;1]
    epsilon_vec = [0.75;0.75;0.1;0.75];
    psi_vec = [1.657465;1.657465;22.6463;1.657465]

%Initial guess at V_0
    beta_sto = [  -36.3181  -10.1125    2.5068   -0.9256   14.6718   -0.0813
                   -2.1184    5.8774    0.9602    0.2101    6.9547   -0.0174
                  -15.2078   -0.2725    1.9435   -0.4438    9.8434   -0.0678
                  -19.7272   -2.4002    1.9585   -0.4753   10.8666   -0.0653]
    X = [ones(prod(size(A_grid)),1),reshape(A_grid,[],1),reshape(k_grid,[],1),reshape(A_grid,[],1).*reshape(k_grid,[],1),reshape(A_grid,[],1).*reshape(A_grid,[],1),reshape(k_grid,[],1).*reshape(k_grid,[],1)];

    for calibration = 1:4
        V_sto(calibration,:,:) = 0.*reshape(beta_sto(calibration,:)*X',size(A_grid)) ;
    end
    clear beta_sto X 

%Loop over calibrations
for calibration = 1:4
    %Reset error and write calibration parameters
        error = 1;
        z = 0;
        sigma = sigma_vec(calibration);
        epsilon = epsilon_vec(calibration);
        psi = psi_vec(calibration)
    
    %Load in the appropriate V_0
         V_0 = squeeze(V_sto(calibration,:,:));
        V_1 = V_0;

    clear error_sto
    %Loop until error small
    while error > 1e-2
        z = z+1;
        %Loop over k and A
        for k_ind = 1:k_num
            for A_ind = 1:2
                %Load in values of K and A
                    k = k_vec(k_ind);
                    A = A_vec(A_ind);
                %Create an interpolating function for the RHS of the value
                %function
                     F = griddedInterpolant(k_grid,A_grid,V_0,'spline','nearest');

                 %Feasibility constraint
                    c = @(x)[-((1-delta)*k+A.*(k^(alpha)).*(x(2).^(1-alpha))+0.001-x(1))];
                    ceq = @(x) 0;
                    nonlinfcn = @(x)deal(c(x),ceq(x));
                
                %A transition and RHS of Value Function
                    A_alt = A_vec(1).*(A==A_vec(2)) + A_vec(2)*(A==A_vec(1));
                    if sigma ~= 1
                        ut = @(x) -((max((A.*(k.^alpha).*(x(2).^(1-alpha)) +(1-delta).*k - x(1)),0.0001)   .^(1-sigma))./(1-sigma) - psi.*(epsilon./(1+epsilon)).*x(2).^((1+epsilon)./epsilon) + beta.*0.995.*F(x(1),A) + beta.*0.005.*F(x(1),A_alt));
                    elseif sigma == 1
                        ut = @(x) -((log(max((A.*(k.^alpha).*(x(2).^(1-alpha)) +(1-delta).*k - x(1)),0.0001))) - psi.*(epsilon./(1+epsilon)).*x(2).^((1+epsilon)./epsilon) + beta.*0.995.*F(x(1),A) + beta.*0.005.*F(x(1),A_alt));
                    end
                    
                %Minimize negative RHS of value function utility (start
                %with good guesses if possible)
                    foptions = optimset('Display','off');
                    init = (z==1).*[k,0.99] + (z>1).*[knext_policy(k_ind,A_ind),L_policy(k_ind,A_ind)];
                    [temp1,temp2]=fmincon(ut,init,[],[],[],[],[k_min,0.1],[k_max,1],nonlinfcn,foptions);
 
                %Store the value function and policy functions
                    V_1(k_ind,A_ind) = -temp2;
                    c_policy(k_ind,A_ind) = (A.*(k.^alpha).*(temp1(2).^(1-alpha)) +(1-delta).*k - temp1(1));
                    L_policy(k_ind,A_ind) = temp1(2);
                    knext_policy(k_ind,A_ind) = temp1(1);                
            end
        end
        
%         %Howard's Improvement Algorithm: only start when solutions are
%         %fairly smooth.  Linearly interpolate so things don't go crazy.
%             if z > 10 & z < 30 
%                     for z2 = 1:20
%                          F = griddedInterpolant(k_grid,A_grid,V_1,'linear','nearest');
%                         for k_ind = 1:k_num
%                             for A_ind = 1:2
%         %                             [k_ind,A_ind]
%                                 k = k_vec(k_ind);
%                                 A = A_vec(A_ind);
%                                 A_alt = A_vec(1).*(A==A_vec(2)) + A_vec(2)*(A==A_vec(1));
%                                 if sigma ~= 1
%                                     ut = @(x) ((max((A.*(k.^alpha).*(x(2).^(1-alpha)) +(1-delta).*k - x(1)),0.0001)   .^(1-sigma))./(1-sigma) - psi.*(epsilon./(1+epsilon)).*x(2).^((1+epsilon)./epsilon) + beta.*0.995.*F(x(1),A) + beta.*0.005.*F(x(1),A_alt));
%                                 elseif sigma == 1
%                                     ut = @(x) ((log(max((A.*(k.^alpha).*(x(2).^(1-alpha)) +(1-delta).*k - x(1)),0.0001))) - psi.*(epsilon./(1+epsilon)).*x(2).^((1+epsilon)./epsilon) + beta.*0.995.*F(x(1),A) + beta.*0.005.*F(x(1),A_alt));
%                                 end
%                                 V_1(k_ind,A_ind) = ut([knext_policy(k_ind,A_ind),L_policy(k_ind,A_ind)]);
%                             end
%                         end
%                     end
%             end
        
    %Produce updating graphs of value function convergence
        %         figure(1)
        %         hold all
        %         subplot(1,2,1)
        %         plot(V_1(:,1))
        %         hold on
        %         drawnow
        %         subplot(1,2,2)
        %         plot(V_1(:,2))
        %         hold on
        %         drawnow
 
    %Determine error, update value function
        error = max(reshape(abs(V_0-V_1),[],1));
        V_0 = V_1;
        error_sto(z) = error
    end
    %Store policy functions for the specific calibration
        c_policy_sto(calibration,:,:) = c_policy;
        L_policy_sto(calibration,:,:) = L_policy;
        knext_policy_sto(calibration,:,:) = knext_policy;
        V_sto(calibration,:,:) = V_1;
end

%Examine the k policy function for the first calibration
    % figure(2)
    % hold all
    % plot(k_vec,knext_policy_sto(1,:,1),'-r')
    % hold on
    % plot(k_vec,knext_policy_sto(1,:,2),'-b')
    % plot(k_vec,k_vec,'--k')

 
 %Simulate all four calibrations
for calibration = 1:4
    k_sim(calibration,1) = 3.42342;
    A_sim(calibration,1:100) = A_vec(1);
    A_sim(calibration,101:200) = A_vec(2);
     
    pC = scatteredInterpolant(reshape(k_grid,[],1),reshape(A_grid,[],1),reshape(c_policy_sto(calibration,:,:),[],1),'linear','nearest');
    pL = scatteredInterpolant(reshape(k_grid,[],1),reshape(A_grid,[],1),reshape(L_policy_sto(calibration,:,:),[],1),'linear','nearest');
    pknext = scatteredInterpolant(reshape(k_grid,[],1),reshape(A_grid,[],1),reshape(knext_policy_sto(calibration,:,:),[],1),'linear','nearest');
 
        for t = 1:200
                c_sim(calibration,t) = pC(k_sim(calibration,t),A_sim(calibration,t));
                L_sim(calibration,t) = pL(k_sim(calibration,t),A_sim(calibration,t));
                k_sim(calibration,t+1) = pknext(k_sim(calibration,t),A_sim(calibration,t));
        end
end


%Graph the simulations
    figure(3)
    subplot(3,1,1)
    hold all
    plot(c_sim')
    legend('IES=0.5,epsilon=0.75','IES=20,epsilon=0.75','IES=1,epsilon=0.1','IES=1,epsilon=0.75')
    title('C')
    subplot(3,1,2)
    plot(L_sim')
    title('L')
    subplot(3,1,3)
    plot(k_sim')
    title('K')
    hold all

%If you want, store a fairly good approximation of the value function for
%later use
    for calibration = 1:4
        Y = reshape(V_sto(calibration,:,:),[],1);
        X = [ones(length(Y),1),reshape(A_grid,[],1),reshape(k_grid,[],1),reshape(A_grid,[],1).*reshape(k_grid,[],1),reshape(A_grid,[],1).*reshape(A_grid,[],1),reshape(k_grid,[],1).*reshape(k_grid,[],1)];
        beta_sto(calibration,:)=inv(X'*X)*X'*Y
    end