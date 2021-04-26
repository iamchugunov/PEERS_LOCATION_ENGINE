config = Config();
config.sigma_ksi = 0.01;

y = PD_UWB * config.c;
RD = [y(2,:) - y(1,:); y(3,:) - y(1,:); y(4,:) - y(1,:)];
StateVector = [2.77373859156927;1.77647863953047;1.32120831011717];
% 
X1(:,1) = [StateVector(1,1);0;StateVector(2,1);0];
Fil1 = ToAEKF_RD(X1(:,1), RD(:,1), config);
% 
X2(:,1) = [StateVector(1,1);0;StateVector(2,1);0;StateVector(3,1)*config.c];
Fil2 = ToAEKF_const_per(X2(:,1), y(:,1), config);
% 
% X3(:,1) = [StateVector(1,1);StateVector(2,1);StateVector(3,1);StateVector(4,1);StateVector(5,1)*config.c;];
% Fil3 = ToAEKF_const_perh(X3(:,1), y(:,1), config);


d = 1;
for i = 1:length(y)
   [X0(:,i), dop(:,i)] = coord_solver2D(y(:,i), config.posts, [1;1;1], config.hei); 
%    [Xd(:,i), dPR] = NavSolver_D(R(:,i), config.posts, [StateVector(1,i);StateVector(3,i)], config.hei);
    if i > 1
        dt(i) = mean(y(:,i) - y(:,i-1))/config.c;
        dt(i) = (y(1,i) - y(1,i-1))/config.c;
        if dt(i) < 0
            dt(i) = dt(i) + config.T_max;
            X2(5,i-1) = X2(5,i-1) - config.T_max*config.c;
            Fil2.X(5) = X2(5,i-1);
        end
            
%         
        Fil1 = Fil1.Update(RD(:,i), dt(i), config);
        X1(:,i) = Fil1.X;
%         
        Fil2 = Fil2.Update(y(:,i), dt(i), config);
        X2(:,i) = Fil2.X;
%         dt11(:,i) = Fil2.dt_raw;
%         dt12(:,i) = Fil2.dt_fil;
%         
%         Fil3 = Fil3.Update(y(:,i), period(i-1) + normrnd(0, 0*10e-9), config);
%         X3(:,i) = Fil3.X;
%         
    end
end

% dt11(1) = [];
% dt12(1) = [];
% dt(1) = [];
% period(end) = [];
% 
X0(3,:) = X0(3,:)/config.c;
X2(5,:) = X2(5,:)/config.c;
% X3(5,:) = X3(5,:)/config.c;
% 
% errd = (StateVector([1 3],1:end-d) - Xd([1 2],1:end-d));
% errmnk = (StateVector([1 2 3],1:end-d) - X0([1 2 3],1:end-d));
% errf1 = (StateVector([1 2],1:end-d) - X1([1 3],1:end-d));
% errf2 = (StateVector([1 2 3],1:end-d) - X2([1 3 5],1:end-d));
% errf3 = (StateVector([1 3 5],1:end-d) - X3([1 3 5],1:end-d));
% 
% 
figure(1)
plot(config.posts(1,:),config.posts(2,:),'vk','linewidth',2)
grid on
hold on
daspect([1 1 1])
plot(X0(1,:),X0(2,:),'g')
plot(X1(1,:),X1(3,:),'b.-','linewidth',2)
% plot(Xd(1,:),Xd(2,:),'k-.','linewidth',1)
plot(X2(1,:),X2(3,:),'r-.','linewidth',2)
% legend('posts','ÐÄ','ÐÄÔ','Ä','Ô1')
% 
% 
% figure(2)
% grid on
% title('Îøèáêà ïî õ')
% hold on
% plot(errmnk(1,:),'g')
% plot(errf1(1,:),'b','linewidth',2)
% % plot(errd(1,:),'k','linewidth',1)
% plot(errf2(1,:),'r','linewidth',2)
% xlabel('k, òàêòû')
% ylabel('x, ì')
% % legend('ÐÄ','ÐÄÔ','Ä','Ô1')
% % 
% figure(3)
% grid on
% title('Îøèáêà ïî y')
% hold on
% plot(errmnk(2,:),'g')
% plot(errf1(2,:),'b','linewidth',2)
% % plot(errd(2,:),'k','linewidth',1)
% plot(errf2(2,:),'r','linewidth',2)
% xlabel('k, òàêòû')
% ylabel('y, ì')
% legend('ÐÄ','ÐÄÔ','Ä','Ô1')
% % 
% figure(4)
% grid on
% title('Îøèáêà ïî âðåìåíè èçëó÷åíèÿ')
% hold on
% plot(errmnk(3,:),'g')
% plot(errf2(3,:),'r','linewidth',2)
% % plot(errf3(3,:),'b','linewidth',2)
% xlabel('k, òàêòû')
% ylabel('T_{èçë}, ñåê')
% legend('ÐÄ','Ô1')
% 
% fprintf('=======================================================================================\n')
% fprintf('Ïî x:\n')
% fprintf(['ÐÄ\tÌÎ: ' num2str(mean(errmnk(1,:))) ' ì\tÑÊÎ: ' num2str(std(errmnk(1,:))) ' ì\n'] )
% fprintf(['ÐÄÔ\tÌÎ: ' num2str(mean(errf1(1,:))) ' ì\tÑÊÎ: ' num2str(std(errf1(1,:))) ' ì\n'] )
% fprintf(['Ä\tÌÎ: ' num2str(mean(errd(1,:))) ' ì\tÑÊÎ: ' num2str(std(errd(1,:))) ' ì\n'] )
% fprintf(['Ô1\tÌÎ: ' num2str(mean(errf2(1,:))) ' ì\tÑÊÎ: ' num2str(std(errf2(1,:))) ' ì\n'] )
% fprintf('Ïî y:\n')
% fprintf(['ÐÄ\tÌÎ: ' num2str(mean(errmnk(2,:))) ' ì\tÑÊÎ: ' num2str(std(errmnk(2,:))) ' ì\n'] )
% fprintf(['ÐÄÔ\tÌÎ: ' num2str(mean(errf1(2,:))) ' ì\tÑÊÎ: ' num2str(std(errf1(2,:))) ' ì\n'] )
% fprintf(['Ä\tÌÎ: ' num2str(mean(errd(2,:))) ' ì\tÑÊÎ: ' num2str(std(errd(2,:))) ' ì\n'] )
% fprintf(['Ô1\tÌÎ: ' num2str(mean(errf2(2,:))) ' ì\tÑÊÎ: ' num2str(std(errf2(2,:))) ' ì\n'] )
% fprintf('Ïî âðåìåíè èçëó÷åíèÿ:\n')
% fprintf(['ÐÄ\tÌÎ: ' num2str(mean(errmnk(3,:))) ' ñ\tÑÊÎ: ' num2str(std(errmnk(3,:))) ' ñ\n'] )
% fprintf(['Ô1\tÌÎ: ' num2str(mean(errf2(3,:))) ' ñ\tÑÊÎ: ' num2str(std(errf2(3,:))) ' ñ\n'] )
% fprintf('=======================================================================================\n')