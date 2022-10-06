clear

k_min = 0;
k_max = 0.8;
k_num = 100;
k_vec = linspace(k_min,k_max,k_num);

w_min = 1;
w_max = 1.2;
w_num = 2;
w_vec = linspace(w_min,w_max,w_num);

r_min = 0.05;
r_max = 0.1;
r_num = 2;
r_vec = linspace(r_min,r_max,r_num);

beta = 1./(1+r_min)
[k_grid,w_grid,r_grid]=meshgrid(k_vec,w_vec,r_vec);

V_0a = -23.3510*ones(size(k_grid));
V_1a = V_0a;

V_0b = V_0a;
V_1b = V_1a;
foptions = optimset('Display','off');

c_choice_a = NaN(size(V_0a));
c_choice_b = NaN(size(V_0a));
L_choice_a = NaN(size(V_0a));
L_choice_b = NaN(size(V_0a));
knext_choice_a = NaN(size(V_0a));
knext_choice_b = NaN(size(V_0a));

error = Inf;
counter = 0;
tic
while error > 0.001
    counter = counter+1;
    [counter,error,toc/60]
    for k_ind = 1:k_num
        for w_ind = 1:w_num
            for r_ind = 1:r_num
                k=k_vec(k_ind);
                w=w_vec(w_ind);
                r=r_vec(r_ind);
                ut_a = @(c,L,knext) log(c)+log(1-L)+beta*interp3(k_grid,w_grid,r_grid,V_0a,knext,w_min,r_min,'makima');
                ut_b = @(c,L,knext) log(c)+log(1-L)+beta*interp3(k_grid,w_grid,r_grid,V_0b,knext,w,r_min,'makima');
                %c-w*L+wnext<=+(1+r)*k
                A=[1,-w,1];
                B=(1+r)*k;
                [temp1,temp2] = fmincon(@(x)-ut_a(x(1),x(2),x(3)),[0.1,0.2,0.001],A,B,[],[],[0.0001,0,0],[Inf,0.999,w_max],[],foptions);
                V_1a(w_ind,k_ind,r_ind)=-temp2;
                c_choice_a(w_ind,k_ind,r_ind) = temp1(1);
                L_choice_a(w_ind,k_ind,r_ind) = temp1(2);
                knext_choice_a(w_ind,k_ind,r_ind) = temp1(3);

                [temp1,temp2] = fmincon(@(x)-ut_b(x(1),x(2),x(3)),[0.1,0.2,0.001],A,B,[],[],[0.0001,0,0],[Inf,0.999,w_max],[],foptions);
                V_1b(w_ind,k_ind,r_ind)=-temp2;
                c_choice_b(w_ind,k_ind,r_ind) = temp1(1);
                L_choice_b(w_ind,k_ind,r_ind) = temp1(2);
                knext_choice_b(w_ind,k_ind,r_ind) = temp1(3);
            end
        end
    end
    error = max(abs(reshape(V_1a-V_0a,[],1)))+max(abs(reshape(V_1b-V_0b,[],1)))
    V_0a=V_1a;
    V_0b=V_1b;
    figure(1)
    plot(squeeze(V_1a(1,:,1)))
    hold on
    plot(squeeze(V_1b(1,:,1)))
    drawnow    
end


%Now simulate an ordinary person
t = 0;
w_sim = w_min;
r_sim = r_min;
k_sim = 0.5;
while t < 230
     t=t+1
     
    ut = @(c,L,knext) log(c)+log(1-L)+beta*interp3(k_grid,w_grid,r_grid,V_0a,knext,w_min,r_min,'makima');
    %c-w*L+wnext<=+(1+r)*k
    A=[1,-w_sim(t),1];
    B=(1+r_sim(t))*k_sim(t);
    
    c_init = interp3(k_grid,w_grid,r_grid,c_choice_a,k_sim(t),w_sim(t),r_sim(t),'makima');
    L_init = interp3(k_grid,w_grid,r_grid,L_choice_a,k_sim(t),w_sim(t),r_sim(t),'makima');
    knext_init = interp3(k_grid,w_grid,r_grid,knext_choice_a,k_sim(t),w_sim(t),r_sim(t),'makima');

    [temp1,temp2] = fmincon(@(x)-ut_a(x(1),x(2),x(3)),[c_init,L_init,knext_init],A,B,[],[],[0.0001,0,0],[Inf,0.999,w_max],[],foptions);

     c_sim(t) = temp1(1);
     L_sim(t) = temp1(2);
     k_sim(t+1) = temp1(3);
     w_sim(t+1) = w_sim(t);
     if t == 200
         w_sim(t+1) = w_max;
     end
     if t == 201
         w_sim(t+1) = w_min;
     end
     r_sim(t+1) = r_sim(t);
end

figure(2)
subplot(3,2,1)
plot(c_sim(150:230))
title('Consumption')
subplot(3,2,2)
plot(c_sim(150:230))
title('Labor')
subplot(3,2,3)
plot(c_sim(150:230))
title('Wealth')
subplot(3,2,4)
plot(w_sim(150:230))
title('Wage')
subplot(3,2,5)
plot(r_sim(150:230))
title('Interest Rate')
