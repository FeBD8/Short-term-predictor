function mercoledi_stimato = prediz(in)

mercoledi = in(1);
giovedi = in(2);
venerdi = in(3);
% sabato e domenica unused
sabato = in(4);
domenica = in(5);
lunedi = in(6);
martedi = in(7);

% Caricamento dei dati per la stima iniziale

Tab = readtable('gasITAday.xlsx','Range', 'A2:C732');

v_mercoledi = zeros();
v_giovedi = zeros();
v_venerdi = zeros();
% sabato e domenica unused
v_lunedi = zeros();
v_martedi = zeros();
y_mercoledi = zeros();

c = 0;
for i=1:7:722
    c=c+1;  
    v_mercoledi(c) = Tab.dati(i+1);
    v_giovedi(c) = Tab.dati(i+2);
    v_venerdi(c) = Tab.dati(i+3);
    % sabato e domenica unused
    v_lunedi(c) = Tab.dati(i+6);
    v_martedi(c) = Tab.dati(i+7);
    
    y_mercoledi(c) = Tab.dati(i+8);
    
end

v_mercoledi = v_mercoledi';
v_giovedi = v_giovedi';
v_venerdi = v_venerdi';
% sabato e domenica unused
v_lunedi = v_lunedi';
v_martedi = v_martedi';

y_mercoledi = y_mercoledi';

% Elementi passati nella funzione e posti in un vettore

dati_giorni = [mercoledi giovedi venerdi  lunedi martedi];

phi = [v_mercoledi(:) v_giovedi(:) v_venerdi(:)  ...
      v_lunedi(:) v_martedi(:)];
 
theta_capp = lscov(phi,y_mercoledi);
mercoledi_stimato = dati_giorni * theta_capp;

% PLOT DELLA SETTIMANA CON IL MERCOLEDI SUCCESSIVO
% Nel plot viene raffigurato l'andamento della settimana da mercoledi 
% fino a venerdi (in colore blu), mentre il mercoledi stimato è in rosso.

v_giorni = 1:1:7;
dati = [mercoledi giovedi venerdi sabato domenica lunedi martedi];
figure(1)
scatter(v_giorni,dati)
hold on
scatter(8,mercoledi_stimato,'r')
grid on
xlabel("Giorni della settimana (da mercoledi a mercoledi successivo)")
ylabel("Consumo di gas nella settimana")
legend('Giorni della settimana','Mercoledi stimato')

