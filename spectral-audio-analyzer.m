clc;
clear;

%Frequência de amostragem igual a 8kHz, números de bits da codificação e
%numeros de canais(estéreo)
Fs = 8000;
nbits = 8;
ch = 1;

%AQUISIÇÃO DO ÁUDIO=================================================
%Cria um objeto para a gravação do áudio com a frequência de amostragem de 8kHz e 8 bits por amostra 
objetoGravacao = audiorecorder(Fs, nbits, ch);

%Grava o áudio até o usuário pressionar enter
disp('========GRAVAÇÃO INICIADA========');
disp('Pressione enter para finalizar...');
record(objetoGravacao);
input('');

%Armazena a amplitude do sinal em cada instante de gravação
audioOriginalTempo = getaudiodata(objetoGravacao);


%JANELAMENTO DO AUDIO===============================================
%audioJanelado = audioOriginalTempo * hamming(audioOriginalTempo)



%TRANSFORMADA DO ÁUDIO============================================
%Calcula a FFT
audioOriginalFrequencia = fft(audioOriginalTempo);
%audioOriginalFrequencia = fft(audioJanelado);

%Desloca ela na frequência para mostrar em 0Hz
audioOriginalFrequencia = fftshift(audioOriginalFrequencia); 

%Pega o número de amostras da transformada
n = length(audioOriginalTempo);

%A frequência de range
f = (-n/2:n/2-1)*(Fs/n);      

%Calcula o módulo tirado a parte conjugada(fase) da transformada
audioOriginalFrequenciaE = abs(audioOriginalFrequencia).^2/n;    


%OPÇÕES DE VISUALIZAÇÃO DE RESULTADOS===============================
escolha = 1;
while escolha ~= 2
    clc;
    escolha = input('[1] - Execução do áudio original\n[2] - Plotar gráficos e sair\nEscolha: ');
    if escolha == 1
        sound(audioOriginalTempo);
    elseif escolha == 2
        subplot(211), plot(audioOriginalTempo, 'b'),
        axis tight, title('Áudio no domínio do Tempo'),
        xlabel('tempo(s)')
        ylabel('x(t)')

        subplot(212), plot(f, audioOriginalFrequenciaE, 'b'),
        legend('Normal'),
        axis tight, title('Áudio no domínio da Frequência'),
        xlabel('Frequência(Hz)')
        ylabel('Amplitude')
    end
    
end
