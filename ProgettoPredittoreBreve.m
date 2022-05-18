clc 
close all 
clear 

%% LETTURA DEI DATI

Tab_due_anni = readtable('gasITAday.xlsx','Range','A2:C732');
Tab_due_anni.Properties.VariableNames = {'giorno_anno','giorno_settimana','dati'};

figure(1)
giorni2Anni = linspace(1,730,730);
grid on
hold on
plot(giorni2Anni, Tab_due_anni.dati, 'k')
title('Consumo del gas in due anni')

% Divido i dati in primo anno (identificazione) e secondo anno (validazione)
Tab_primo_anno = readtable('gasITAday.xlsx','Range', 'A2:C367');
Tab_primo_anno.Properties.VariableNames = {'giorno_anno','giorno_settimana','dati'};

Tab_secondo_anno = readtable('gasITAday.xlsx','Range', 'A367:C732');
Tab_secondo_anno.Properties.VariableNames = {'giorno_anno','giorno_settimana','dati'};

% Rappresentazione dei dati di ogni giorno nei due anni, a confronto
figure(2)
giorni1Anno = linspace(1,365,365);
grid on
hold on
plot(giorni1Anno, Tab_primo_anno.dati, 'g')
hold on
plot(giorni1Anno, Tab_secondo_anno.dati, 'b')
title('Consumo del gas in due anni sovrapposti')
legend('Primo anno','Secondo anno');
xlabel("Giorni in un anno")
ylabel("Consumo del gas")

%% CREAZIONE DEI VETTORI DEI GIORNI E CALCOLO DELLA MEDIA SETTIMANALE

% Utilizzo i valori dei dati di consumo dei mercoledi del primo anno 
% come training e i valori del secondo anno come validazione. 

% (prima inizializzo i vettori, per semplificare il lavoro del compilatore).

lunedi = zeros(1,52);
martedi = zeros(1,52);
mercoledi = zeros(1,52);
giovedi = zeros(1,52);
venerdi = zeros(1,52);
sabato = zeros(1,52);
domenica = zeros(1,52);
lunedi_validazione = zeros(1,52);
martedi_validazione = zeros(1,52);
mercoledi_validazione = zeros(1,52);
giovedi_validazione = zeros(1,52);
venerdi_validazione = zeros(1,52);
sabato_validazione = zeros(1,52);
domenica_validazione = zeros(1,52);
mercoledi_totali = zeros(1,104);

c=0;
for i=1:7:358
    c=c+1;
    mercoledi(c) = Tab_primo_anno.dati(i+1);
    giovedi(c) = Tab_primo_anno.dati(i+2);
    venerdi(c) = Tab_primo_anno.dati(i+3);
    sabato(c) = Tab_primo_anno.dati(i+4);
    domenica(c) = Tab_primo_anno.dati(i+5);
    lunedi(c) = Tab_primo_anno.dati(i+6);
    martedi(c) = Tab_primo_anno.dati(i+7);
    
    mercoledi_validazione(c) = Tab_secondo_anno.dati(i);
    giovedi_validazione(c) = Tab_secondo_anno.dati(i+1);
    venerdi_validazione(c) = Tab_secondo_anno.dati(i+2);
    sabato_validazione(c) = Tab_secondo_anno.dati(i+3);
    domenica_validazione(c) = Tab_secondo_anno.dati(i+4);
    lunedi_validazione(c) = Tab_secondo_anno.dati(i+5);
    martedi_validazione(c) = Tab_secondo_anno.dati(i+6);
    
    mercoledi_totali(c) = Tab_primo_anno.dati(i+1);
    mercoledi_totali(c+52) = Tab_secondo_anno.dati(i);
    mercoledi_totali = mercoledi_totali';
end

% Trasformazione dei vettori-riga in vettori-colonna.

mercoledi = mercoledi';
giovedi = giovedi';
venerdi = venerdi';
sabato = sabato';
domenica = domenica';
lunedi = lunedi';
martedi = martedi';

mercoledi_validazione = mercoledi_validazione';
giovedi_validazione = giovedi_validazione';
venerdi_validazione = venerdi_validazione';
sabato_validazione = sabato_validazione';
domenica_validazione = domenica_validazione';
lunedi_validazione = lunedi_validazione';
martedi_validazione = martedi_validazione';

% Creo il vettore y con i mercoledi effettivamente da stimare: quindi in
% questo vettore NON inserisco il primo mercoledi, che utilizzo solo per stimare
% (ma che non può essere stimato, non avendo i 7 valori precedenti).

y_mercoledi_primoanno = mercoledi(2:52);
y_mercoledi_primoanno(52) = Tab_secondo_anno.dati(1);

y_mercoledi_secondoanno = mercoledi_validazione(2:52);
y_mercoledi_secondoanno(52) = Tab_secondo_anno.dati(365);

% Creo i vettori per plottare i dati successivamente:

V_anno = Tab_primo_anno.giorno_anno;
V_merc = (1:1:length(mercoledi))';

%% CALCOLO LA MEDIA dei valori del consumo di gas settimana per settimana,
% per il primo e per il secondo anno.

medie_per_settimana1 = zeros(52,1);
medie_per_settimana2 = zeros(52,1);

j = 0;
for i = 1:7:358
    j = j+1;
    medie_per_settimana1(j) = mean(Tab_primo_anno.dati(i:i+6));
    medie_per_settimana2(j) = mean(Tab_secondo_anno.dati(i:i+6));
end

figure(3)
plot(medie_per_settimana1,'m')
hold on
grid on
hold on
plot(medie_per_settimana2)
title('Medie settimanali del consumo di Gas')
legend('Primo anno','Secondo anno')

%% ULTERIORI GRAFICI UTILI

% Istogramma per vedere la distribuzione dei dati di consumo dei mercoledi

figure(4)
histogram(mercoledi_totali(:),15);
title('Istogramma dei valori del consumo di gas dei mercoledi dei due anni')

% Rappresentazione dei valori di alcune settimane-campione, sovrapposte, 
% in modo da osservare la presenza di un trend condiviso.

sett_camp_1 = [lunedi(17) martedi(17) mercoledi(18) giovedi(18) venerdi(18) sabato(18) domenica(18)];
sett_camp_2 = [lunedi(27) martedi(27) mercoledi(28) giovedi(28) venerdi(28) sabato(28) domenica(28)];
sett_camp_3 = [lunedi(29) martedi(29) mercoledi(30) giovedi(30) venerdi(30) sabato(30) domenica(30)];
sett_camp_4 = [lunedi(30) martedi(30) mercoledi(31) giovedi(31) venerdi(31) sabato(31) domenica(31)];
sett_camp_5 = [lunedi(41) martedi(41) mercoledi(42) giovedi(42) venerdi(42) sabato(42) domenica(42)];
sett_camp_6 = [lunedi(44) martedi(44) mercoledi(45) giovedi(45) venerdi(45) sabato(45) domenica(45)];

figure(5)
giorni_sett = 1:7;
grid on
hold on
scatter(giorni_sett,sett_camp_1,'m')
hold on
scatter(giorni_sett,sett_camp_2,'g')
hold on
scatter(giorni_sett,sett_camp_3,'k')
hold on
scatter(giorni_sett,sett_camp_4,'r')
hold on
scatter(giorni_sett,sett_camp_5,'b')
hold on
scatter(giorni_sett,sett_camp_6,'c')
title('Valori di alcune settimane')
xlabel('Giorno della settimana (1 = Lunedì, 7 = Domenica)')
ylabel('Consumo di Gas')
legend('Settimana #17','Settimana #27','Settimana #29','Settimana #30','Settimana #41','Settimana #44')

% PER QUANTO RIGUARDA I PROSSIMI MODELLI: I VALORI DEL WORKSPACE 
% FANNO RIFERIMENTO AL PROPRIO MODELLO ATTRAVERSO IL NUMERO ALLA FINE 
% DEL NOME (AD ESEMPIO L'AIC2 FA RIFERIMENTO AL MODELLO 2).

%% MODELLO POLINOMIALE DI PRIMO GRADO --- MODELLO 1

% TRAINING

phi1 = [ones(size(mercoledi(:))) mercoledi(:) ...
    giovedi(:) venerdi(:) sabato(:) ...
    domenica(:) lunedi(:) martedi(:)];
theta1_capp = lscov(phi1,y_mercoledi_primoanno);
y_mercoledi_stim1 =  phi1 * theta1_capp;

figure(6)
grid on
hold on
scatter(V_merc,y_mercoledi_primoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_stim1,'ob')
title('Modello del primo ordine - TRAINING')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Primo anno')
legend('Dati','Stima')

% VALIDAZIONE

phi1_validazione = [ones(size(mercoledi_validazione(:))) ... 
    mercoledi_validazione(:) giovedi_validazione(:) ...
    venerdi_validazione(:) sabato_validazione(:) ...
    domenica_validazione(:) lunedi_validazione(:) ...
    martedi_validazione(:)];
y_mercoledi_capp = phi1_validazione * theta1_capp;

[m,n1] = size(phi1_validazione);

figure(7)
grid on
hold on
scatter(V_merc,y_mercoledi_secondoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_capp,'ob')
title('Modello del primo ordine - VALIDAZIONE')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Secondo anno')
legend('Dati','Stima')

errore1 = y_mercoledi_secondoanno(:) - y_mercoledi_capp(:);
SSR1 = (errore1)'*errore1;

%FPE
FPE1 = (m+n1)*SSR1/(m-n1);

%AIC
AIC1 = (2*n1/m) + log(SSR1);

%% MODELLO INTERMEDIO SENZA SABATI E DOMENICHE --- MODELLO 2

% TRAINING

phi2 = [mercoledi(:) giovedi(:) venerdi(:) lunedi(:) martedi(:)];
theta2_capp = lscov(phi2,y_mercoledi_primoanno);
y_mercoledi_stim2 =  phi2 * theta2_capp;

[m,n2] = size(phi2);

figure(8)
grid on
hold on
scatter(V_merc,y_mercoledi_primoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_stim2,'ok')
title('Modello del primo ordine senza sabati e domeniche (SCATTER) - TRAINING')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Primo anno')
legend('Dati','Stima')

%VALIDAZIONE

phi2_validazione = [ mercoledi_validazione(:) giovedi_validazione(:) ...
    venerdi_validazione(:) lunedi_validazione(:) martedi_validazione(:)];
y_mercoledi_capp2 = phi2_validazione * theta2_capp;

figure(9)
grid on
hold on
scatter(V_merc,y_mercoledi_secondoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_capp2,'ok')
title('Modello del primo ordine senza sabati e domeniche - VALIDAZIONE')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Secondo anno')
legend('Dati','Stima')

errore2 = y_mercoledi_secondoanno(:) - y_mercoledi_capp2(:);
SSR2 = (errore2)'*errore2;

%FPE
FPE2 = (m+n2)*SSR2/(m-n2);

%AIC
AIC2 = (2*n2/m) + log(SSR2);

%% MODELLO INTERMEDIO CON ELEMENTI DI SECONDO GRADO --- MODELLO 3

% TRAINING

phi3 = [ones(size(lunedi(:))) mercoledi(:).^2 lunedi(:).^2 martedi(:).^2 ...
   venerdi(:).^2 lunedi(:) martedi(:)  ];
theta3_capp = lscov(phi3,y_mercoledi_primoanno);
y_mercoledi_stim3 = phi3 * theta3_capp;

[m,n3] = size(phi3);

figure(10)
grid on
hold on
scatter(V_merc,y_mercoledi_primoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_stim3,'og')
title('Modello intermedio senza sabati e domeniche con elementi di secondo grado - TRAINING')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Primo anno')
legend('Dati','Stima')

%VALIDAZIONE

phi3_validazione = [ones(size(lunedi(:))) mercoledi_validazione(:).^2 ...
    lunedi_validazione(:).^2 martedi_validazione(:).^2 ...
    venerdi_validazione(:).^2 lunedi_validazione(:) martedi_validazione(:)];
y_mercoledi_capp3 = phi3_validazione * theta3_capp;

figure(11)
grid on
hold on
scatter(V_merc,y_mercoledi_secondoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_capp3,'og')
title('Modello intermedio - VALIDAZIONE')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Secondo anno')
legend('Dati','Stima')

errore3 = y_mercoledi_secondoanno(:) - y_mercoledi_capp3(:);
SSR3 = (errore3)'*errore3;

%FPE
FPE3 = (m+n3)*SSR3/(m-n3);

%AIC
AIC3 = (2*n3/m) + log(SSR3);

%% MODELLO POLINOMIALE DI SECONDO GRADO --- MODELLO 4

% TRAINING

phi4 = [ones(size(lunedi_validazione))  giovedi(:).^2  venerdi(:).^2  sabato(:).^2 ...
       lunedi(:).^2  martedi(:).^2  lunedi(:).*mercoledi(:)  lunedi(:).*giovedi(:) ...
       lunedi(:).*sabato(:)  martedi(:).*giovedi(:)  martedi(:).*venerdi(:) ...
       mercoledi(:).*giovedi(:) mercoledi(:).*venerdi(:)  mercoledi(:).*sabato(:) ...
       mercoledi(:).*domenica(:)  giovedi(:).*domenica(:)  sabato(:).*domenica(:)];
theta4_capp = lscov(phi4,y_mercoledi_primoanno);
y_mercoledi_stim4 =  phi4 * theta4_capp;

figure(12)
grid on
hold on
scatter(V_merc,y_mercoledi_primoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_stim4,'*c')
title('Modello del secondo ordine - TRAINING')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Primo anno')
legend('Dati','Stima')

%VALIDAZIONE

phi4_validazione = [ones(size(lunedi_validazione)) giovedi_validazione(:).^2 ...
     venerdi_validazione(:).^2  sabato_validazione(:).^2 ...
     lunedi_validazione(:).^2 martedi_validazione(:).^2 ...
     lunedi_validazione(:).*mercoledi_validazione(:) ...
     lunedi_validazione(:).*giovedi_validazione(:) ...
     lunedi_validazione(:).*sabato_validazione(:)...
     martedi_validazione(:).*giovedi_validazione(:)...
     martedi_validazione(:).*venerdi_validazione(:) ...
     mercoledi_validazione(:).*giovedi_validazione(:) ...
     mercoledi_validazione(:).*venerdi_validazione(:) ...
     mercoledi_validazione(:).*sabato_validazione(:) ...
     mercoledi_validazione(:).*domenica_validazione(:) ...
     giovedi_validazione(:).*domenica_validazione(:) ...
     sabato_validazione(:).*domenica_validazione(:)];
 
% ELEMENTI TOLTI : venerdi_validazione(:).*domenica_validazione(:) , 
% venerdi_validazione(:).*sabato_validazione(:) ,
% giovedi_validazione(:).*sabato_validazione(:) , 
% giovedi_validazione(:).*venerdi_validazione(:) , 
% martedi_validazione(:).*domenica_validazione(:) ,
% martedi_validazione(:).*sabato_validazione(:) ,
% martedi_validazione(:).*mercoledi_validazione(:) ,
% lunedi_validazione(:).*domenica_validazione(:) ,
% lunedi_validazione(:).*venerdi_validazione(:) ,
% lunedi_validazione(:).*martedi_validazione(:) ,
% domenica_validazione(:).^2 , mercoledi_validazione(:).^2
 
y_mercoledi_capp4 = phi4_validazione * theta4_capp;

[m,n4] = size(phi4_validazione);

figure(13)
grid on
hold on
scatter(V_merc,y_mercoledi_secondoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_capp4,'*c')
title('Modello del secondo ordine - VALIDAZIONE')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Secondo anno')
legend('Dati','Stima')

errore4 = y_mercoledi_secondoanno(:) - y_mercoledi_capp4(:);
SSR4 = (errore4)'*errore4;

% %FPE
FPE4 = (m+n4)*SSR4/(m-n4);
 
%AIC
AIC4 = (2*n4/m) + log(SSR4);

%% PROVA RETE NEURALE

net = feedforwardnet(1);
net = configure(net,mercoledi,y_mercoledi_primoanno);
net = train(net,mercoledi,y_mercoledi_primoanno);
y_mercoledi_rete = net(mercoledi_validazione);

figure(14)
grid on
hold on
scatter(V_merc,y_mercoledi_secondoanno,'xr')
hold on
scatter(V_merc,y_mercoledi_rete,'om')
title('Modello con Rete Neurale - VALIDAZIONE')
xlabel('Mercoledi dell anno')
ylabel('Consumo del Gas - Secondo anno')
legend('Dati','Stima')

errore5 = y_mercoledi_secondoanno(:) - y_mercoledi_rete(:);
SSR5 = (errore5)' * errore5;

%% RICERCA DEL MIGLIOR MODELLLO ATTRAVERSO I TEST DI VALIDAZIONE

% CROSSVALIDAZIONE

V_SSR = [SSR1 SSR2 SSR3 SSR4 SSR5];
SSR_minimo = min(V_SSR);

%FPE

V_FPE = [FPE1 FPE2 FPE3 FPE4];
FPE_minimo = min(V_FPE);

%AIC

V_AIC = [AIC1 AIC2 AIC3 AIC4];
AIC_minimo = min(V_AIC);
