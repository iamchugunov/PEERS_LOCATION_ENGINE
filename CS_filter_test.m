R2 = 2.001985e-08;
R3 = 2.606000e-08;
R4 = 1.668321e-08;

dw_unit = (1.0/499.2e6/128.0);
T_max = 2^40 * dw_unit;

StateVector2 = [outCS(2,3) - outCS(1,3) - R2; 0];
Dx2 = ones(2,2);
Dx2(1,1) = 2.455134181397120e-20;
Dx2(2,2) = 1.943878329700895e-19;
Dx2(1,2) = 4.210048939259931e-20;
Dx2(2,1) = Dx2(1,2);
T2_prev = outCS(1,3);
StateVector3 = [outCS(3,3) - outCS(1,3) - R3; 0];
Dx3 = ones(2,2);
Dx3(1,1) = 2.455134181397120e-20;
Dx3(2,2) = 1.943878329700895e-19;
Dx3(1,2) = 4.210048939259931e-20;
Dx3(2,1) = Dx3(1,2);
T3_prev = outCS(1,3);
StateVector4 = [outCS(4,3) - outCS(1,3) - R4; 0];
Dx4 = ones(2,2);
Dx4(1,1) = 6e-20;
Dx4(2,2) = 6e-20;
Dx4(1,2) = 6e-20;
Dx4(2,1) = Dx4(1,2);
T4_prev = outCS(1,3);
k2 = 0;
for i = 4:length(outCS)
%     dt = outCS(1,i) - outCS(1,i-1); 
%     if dt < 0
%         dt = dt + T_max;
%     end
    if outCS(2,i) && outCS(1,i)
        dt2 = outCS(1,i) - T2_prev;
        T2_prev = outCS(1,i);
        if dt2 < 0
            dt2 = dt2 + T_max;
        end
%         dt2 = 0.15;
        [StateVector2, Dx2, nev2(i) ] = CS_filter( StateVector2, Dx2, dt2, outCS(1,i), outCS(2,i), R2 );
        k2 = k2 + 1;
        X2(:,k2) = StateVector2;
        D11_2(k2) = Dx2(1,1);
        D22_2(k2) = Dx2(2,2);
        D12_2(k2) = Dx2(1,2);
        D21_2(k2) = Dx2(2,1);
    end
    if outCS(3,i) && outCS(1,i)
        dt3 = outCS(1,i) - T3_prev;
        T3_prev = outCS(1,i);
        if dt3 < 0
            dt3 = dt3 + T_max;
        end
        [StateVector3, Dx3, nev3(i) ] = CS_filter( StateVector3, Dx3, dt3, outCS(1,i), outCS(3,i), R3 );
        X3(:,i) = StateVector3;
        D11_3(i) = Dx3(1,1);
        D22_3(i) = Dx3(2,2);
        D12_3(i) = Dx3(1,2);
        D21_3(i) = Dx3(2,1);
    end
    if outCS(4,i) && outCS(1,i)
        dt4 = outCS(1,i) - T4_prev;
        T4_prev = outCS(1,i);
        if dt4 < 0
            dt4 = dt4 + T_max;
        end
        [StateVector4, Dx4, nev4(i) ] = CS_filter( StateVector4, Dx4, dt4, outCS(1,i), outCS(4,i), R4 );
        X4(:,i) = StateVector4;
        D11_4(i) = Dx4(1,1);
        D22_4(i) = Dx4(2,2);
        D12_4(i) = Dx4(1,2);
        D21_4(i) = Dx4(2,1);
    end
        
end