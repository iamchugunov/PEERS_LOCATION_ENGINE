config  = config_build();
config.sigma_n = 0.1;
posts = [anchors(1).pos anchors(2).pos anchors(3).pos anchors(4).pos];
config.PostsENU = posts;
cords = tags(1).coords(:,10:end);
toa_m = tags(1).corrected_meas(1:4,10:end) * 3e8;
toa_ns = tags(1).corrected_meas(1:4,10:end) * 1e9;



T = 1;
[X, Xf] = make_esimation_2D(toa_ns, config, T);

figure(1)
plot(posts(1,:),posts(2,:),'v')
hold on
grid on
xlim([min(posts(1,:)) - 3 max(posts(1,:)) + 3])
ylim([min(posts(2,:)) - 3 max(posts(2,:)) + 3])
daspect([1 1 1])
plot(cords(2,:),cords(3,:),'.-')
plot(X(1,:),X(4,:),'.-b','linewidth',2)
plot(Xf(1,:),Xf(4,:),'.-r','linewidth',2)
legend('anch','mnk','approx','approx+fil')

figure(2)
subplot(211)
plot(cords(1,:),cords(2,:),'.')
grid on
hold on
ylim([-3 10])
plot(cords(1,:),cords(3,:),'.')
plot(cords(1,:),cords(4,:),'.')

subplot(212)
plot(cords(1,:),toa_m(2,:) - toa_m(1,:),'.')
grid on
hold on
ylim([-15 15])
plot(cords(1,:),toa_m(3,:) - toa_m(1,:),'.')
plot(cords(1,:),toa_m(4,:) - toa_m(1,:),'.')