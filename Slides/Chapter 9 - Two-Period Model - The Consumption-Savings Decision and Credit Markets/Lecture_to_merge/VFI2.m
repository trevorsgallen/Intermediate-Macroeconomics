clear
% close all

k_min = 0;
k_max = 0.4;
k_num = 200;
k_vec = linspace(k_min,k_max,k_num);

beta = 1./(1+0.05)

V_0a = -28.0484*ones(size(k_vec))+log(1+k_vec);
V_1a = V_0a;

V_0b = V_0a;
V_1b = V_1a;
foptions = optimset('Display','off');

c_choice_a = 0.001*ones(size(V_0a));
L_choice_a = 0.2*ones(size(V_0a));
knext_choice_a = min(k_vec)*ones(size(V_0a));

V_0b = V_0a;
V_1b = V_1a;
c_choice_b = c_choice_a;
L_choice_b = L_choice_a;
knext_choice_b = knext_choice_a;

V_0c = V_0a;
V_1c = V_1a;
c_choice_c = c_choice_a;
L_choice_c = L_choice_a;
knext_choice_c = knext_choice_a;

                
error = Inf;
counter = 0;
tic
while error > 0.0001  & counter < 200
    counter = counter+1;
    [counter,error,toc/60]
    for k_ind = 1:k_num
        k = k_vec(k_ind);
        w = 1;
        r = 0.05;
        
        k=k_vec(k_ind);
        ut_a = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        %c-w*L+wnext<=+(1+r)*k

        c_init = interp1(k_vec,c_choice_a,k,'pchip');
        L_init = interp1(k_vec,L_choice_a,k,'pchip');
        knext_init = interp1(k_vec,knext_choice_a+0.0001,k,'pchip');
        A=[1,-w,1];
        B=(1+r)*k;
        [temp1,temp2] = fmincon(@(x)-ut_a(x(1),x(2),x(3)),[c_init,L_init,knext_init],A,B,[],[],[0.0001,0,0],[Inf,0.999,k_max],[],foptions);
        V_1a(k_ind)=-temp2;
        c_choice_a(k_ind) = temp1(1);
        L_choice_a(k_ind) = temp1(2);
        knext_choice_a(k_ind) = temp1(3);
        
        %Permanent higher wage
        w = 1.1;
        ut_a = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0b,knext,'pchip');
        c_init = interp1(k_vec,c_choice_b,k,'pchip');
        L_init = interp1(k_vec,L_choice_b,k,'pchip');
        knext_init = interp1(k_vec,knext_choice_b+0.0001,k,'pchip');
        A=[1,-w,1];
        B=(1+r)*k;
        [temp1,temp2] = fmincon(@(x)-ut_a(x(1),x(2),x(3)),[c_init,L_init,knext_init],A,B,[],[],[0.0001,0,0],[Inf,0.999,k_max],[],foptions);
        V_1b(k_ind)=-temp2;
        c_choice_b(k_ind) = temp1(1);
        L_choice_b(k_ind) = temp1(2);
        knext_choice_b(k_ind) = temp1(3);
        
        %Higer interest rate
        w=1;
        r = 0.1;
        ut_a = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0c,knext,'pchip');
        c_init = interp1(k_vec,c_choice_c,k,'pchip');
        L_init = interp1(k_vec,L_choice_c,k,'pchip');
        knext_init = interp1(k_vec,knext_choice_c+0.0001,k,'pchip');
        A=[1,-w,1];
        B=(1+r)*k;
        [temp1,temp2] = fmincon(@(x)-ut_a(x(1),x(2),x(3)),[c_init,L_init,knext_init],A,B,[],[],[0.0001,0,0],[Inf,0.999,k_max],[],foptions);
        V_1c(k_ind)=-temp2;
        c_choice_c(k_ind) = temp1(1);
        L_choice_c(k_ind) = temp1(2);
        knext_choice_c(k_ind) = temp1(3);


    end
    error = max(abs(reshape(V_1a-V_0a,[],1)))+max(abs(reshape(V_1b-V_0b,[],1)))+max(abs(reshape(V_1c-V_0c,[],1)))
    V_0a=V_1a;
    V_0b=V_1b;
    V_0c=V_1c;
    figure(1)
    plot(k_vec,squeeze(V_1a(1,:,1)))
    hold on
    drawnow    
    
end


%Now simulate an ordinary person
t = 0;
w_sim = [1;1;1;1];
r_sim = [0.05;0.05;0.05;0.05];
k_sim = [k_min;k_min;k_min;k_min];
while t < 230
     t=t+1
    for sim = 1:4

        if sim == 1 
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        end
        if sim == 2 & t < 200 
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        end
        if sim == 2 & t >= 200 
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0b,knext,'pchip');
        end
        if sim == 3 & t < 200 
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        end
        if sim == 3 & t < 200 
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        end
        if sim == 3 & t == 200
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0c,knext,'pchip');
        end
        if sim == 3 & t >= 201
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        end
        if sim == 4
            ut = @(c,L,knext) log(c)+log(1-L)+beta*interp1(k_vec,V_0a,knext,'pchip');
        end
        %c-w*L+wnext<=+(1+r)*k
        A=[1,-w_sim(sim,t),1];
        B=(1+r_sim(sim,t))*k_sim(sim,t);

        c_init = interp1(k_vec,c_choice_a,k_sim(sim,t),'pchip');
        L_init = interp1(k_vec,L_choice_a,k_sim(sim,t),'pchip');
        knext_init = interp1(k_vec,knext_choice_a,k_sim(sim,t),'pchip');

        [temp1,temp2] = fmincon(@(x)-ut(x(1),x(2),x(3)),[c_init,L_init,knext_init],A,B,[],[],[0.0001,0,k_min],[Inf,0.999,k_max],[],foptions);

         c_sim(sim,t) = temp1(1);
         L_sim(sim,t) = temp1(2);
         k_sim(sim,t+1) = temp1(3);
         if t < 200
             k_sim(sim,t+1)=0;
         end
         w_sim(sim,t+1) = w_sim(sim,t);
         r_sim(sim,t+1) = r_sim(sim,t);
         if sim == 1 & t == 200
             w_sim(sim,t+1) = 1.1;
             r_sim(sim,t+1) = r_sim(sim,t);
         end
         if sim == 1 & t == 201
             w_sim(sim,t+1) = 1;
             r_sim(sim,t+1) = r_sim(sim,t);
         end
         if sim == 2 & t == 200
             w_sim(sim,t+1) = 1.01;
             r_sim(sim,t+1) = r_sim(sim,t);
         end
         if sim == 2 & t == 201
             w_sim(sim,t+1) = 1.01;
             r_sim(sim,t+1) = r_sim(sim,t);
         end
         if sim == 3 & t == 200
             w_sim(sim,t+1) = 1;
             r_sim(sim,t+1) = 0.1;
         end
         if sim == 3 & t == 201
             w_sim(sim,t+1) = 1;
             r_sim(sim,t+1) = 0.05;
         end
         if sim == 4 & t == 200
             k_sim(sim,t+1)=k_sim(sim,t+1)+0.2;
         end


    end
end

figure(2)
subplot(2,3,1)
plot(c_sim(1,190:230),'-k')
hold on
plot(c_sim(2,190:230),'-ob')
hold on
plot(c_sim(1,190)*ones(1,230-190),'-xr')
title('Consumption')
subplot(2,3,2)
plot(L_sim(1,190:230),'-k')
hold on
plot(L_sim(2,190:230),'-ob')
hold on
plot(L_sim(190)*ones(1,230-190),'-xr')
title('Labor')
subplot(2,3,3)
plot(k_sim(1,190:230),'-k')
hold on
plot(k_sim(2,190:230),'-ob')
plot(k_sim(190)*ones(1,230-190),'-xr')
legend('Temporary Wage Change','Permanent Wage Change','Baseline','Location','best')
title('Wealth')
subplot(2,3,4)
plot(w_sim(1,190:230),'-k')
hold on
plot(w_sim(2,190:230),'-ob')
plot(w_sim(190)*ones(1,230-190),'-xr')
title('Wage')
subplot(2,3,5)
plot(r_sim(1,190:230),'-k')
hold on
plot(r_sim(2,190:230),'-ob')
plot(r_sim(190)*ones(1,230-190),'-xr')
title('Interest Rate')
saveas(gcf,'~/Dropbox/Econ 352/Fall 2021/Lecture 8 and 9/WageChange.png')


figure(3)
subplot(2,3,1)
plot(c_sim(3,190:230),'-ob')
hold on
plot(c_sim(1,190)*ones(1,230-190),'-xr')
title('Consumption')
subplot(2,3,2)
plot(L_sim(3,190:230),'-ob')
hold on
plot(L_sim(190)*ones(1,230-190),'-xr')
title('Labor')
subplot(2,3,3)
plot(k_sim(3,190:230),'-ob')
hold on
plot(k_sim(190)*ones(1,230-190),'-xr')
title('Wealth')
subplot(2,3,4)
plot(w_sim(3,190:230),'-ob')
hold on
plot(w_sim(190)*ones(1,230-190),'-xr')
legend('Temporary Interest Rate Change','Baseline','Location','Best')
title('Wage')
subplot(2,3,5)
plot(r_sim(3,190:230),'-ob')
hold on
plot(r_sim(190)*ones(1,230-190),'-xr')
title('Interest Rate')
saveas(gcf,'~/Dropbox/Econ 352/Fall 2021/Lecture 8 and 9/IntChange.png')

figure(4)
subplot(2,3,1)
plot(c_sim(4,190:230),'-ob')
hold on
plot(c_sim(1,190)*ones(1,230-190),'-xr')
title('Consumption')
subplot(2,3,2)
plot(L_sim(4,190:230),'-ob')
hold on
plot(L_sim(190)*ones(1,230-190),'-xr')
title('Labor')
subplot(2,3,3)
plot(k_sim(4,190:230),'-ob')
hold on
plot(k_sim(190)*ones(1,230-190),'-xr')
title('Wealth')
subplot(2,3,4)
plot(w_sim(4,190:230),'-ob')
hold on
plot(w_sim(190)*ones(1,230-190),'-xr')
title('Wage')
subplot(2,3,5)
plot(r_sim(4,190:230),'-ob')
hold on
plot(r_sim(190)*ones(1,230-190),'-xr')
legend('Positive Shock to Wealth','Baseline','Location','Best')
title('Interest Rate')
saveas(gcf,'~/Dropbox/Econ 352/Fall 2021/Lecture 8 and 9/WealthShock.png')



