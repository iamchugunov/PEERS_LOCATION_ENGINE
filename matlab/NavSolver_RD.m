function [UserPos,DOP] = NavSolver_RD(SatPos, RD, InitPos)
MaxErr = 1e-3;
MaxIter = 40;
stopflag = 1;
k=0;
UserPos = InitPos;
N = length(InitPos);
rho = zeros(length(RD),1);
H = zeros(length(RD),N);
Niter = 0;
while stopflag
k=k+1;
Niter = Niter + 1;
for m = 1:length(RD)
        rho(m) = -norm(SatPos(1:N,1)-UserPos(1:N)) + norm(SatPos(1:N,m+1)-UserPos(1:N));
    for n = 1:N
        H(m,n) = (SatPos(n,1)-UserPos(n))/(norm(SatPos(1:N,1)-UserPos(1:N)))-(SatPos(n,m+1)-UserPos(n))/norm(SatPos(1:N,m+1)-UserPos(1:N));
    end
end
    DU=UserPos; %Переменная для расчета точности
    dPR=RD-rho; %Невязка по дальностям
    UserPos=UserPos+((H'*H)^(-1))*H'*dPR; %Коррекция текущего решения
    dX=UserPos-DU; %Остаточная ошибка
    DOP=sqrt(trace((H'*H)^(-1))); %Геометрический фактор
    %Критерий останова
    if norm(dX)<=MaxErr
        stopflag=0; %Выход из цикла, если достигнута требуемая точность
    elseif Niter>=MaxIter
            stopflag=0; %Выход из цикла, если достигнуто предельное число итераций
    end
    end
end

