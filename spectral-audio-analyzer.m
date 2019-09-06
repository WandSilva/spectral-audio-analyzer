clc;
clear;

%Frequência de amostragem igual a 8kHz, números de bits da codificação e
%numeros de canais(estéreo)
Fs = 8000;
nbits = 16;
ch = 1;

escolha = 0;
while escolha ~= 10
    clc;
    escolha = input('[1] - Gravar novo sinal \n[2] - Ler arquivo \nEscolha: ');
    if escolha == 1
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
        escolha = 10;
    elseif escolha == 2
        [audioOriginalTempo,Fs] = audioread('sinal1.wav');
        escolha = 10;

    end
end

%JANELAMENTO DO AUDIO===============================================
audioJaneladoTempo = audioOriginalTempo .* hamming(length(audioOriginalTempo),'periodic');

%TRANSFORMADA DO ÁUDIO============================================
%Calcula a FFT
audioOriginalFrequencia = fft(audioOriginalTempo);
audioJaneladoFrequencia = fft(audioJaneladoTempo);

%Pega o número de amostras da transformada
n = length(audioOriginalTempo);

%A frequência de range
f = (-n/2:n/2-1)*(Fs/n);      
%f = (0:n-1) * (Fs/n)

%Calcula o módulo tirado a parte conjugada(fase) da transformada
audioOriginalFrequenciaE = abs(audioOriginalFrequencia);%.^2/n;    
audioJaneladoFrequenciaE = abs(audioJaneladoFrequencia);%.^2/n;    

%Desloca na frequência para mostrar em 0Hz
audioOriginalFrequenciaE =fftshift(audioOriginalFrequenciaE);
audioJaneladoFrequenciaE =fftshift(audioJaneladoFrequenciaE);

%OPÇÕES DE VISUALIZAÇÃO DE RESULTADOS===============================
escolha = 1;
while escolha ~= 5
    clc;
    escolha = input('[1] - Execução do áudio \n[2] - Plotar sinal original \n[3] - Plotar sinal janelado \n[4] - Comparar sinais no tempo \n[5] sair \nEscolha: ');
    if escolha == 1
        sound(audioOriginalTempo);
    elseif escolha == 2
        subplot(211), plot(audioOriginalTempo, 'b'),
        axis tight, title('Sinal original (Tempo)'),
        xlabel('n')
        ylabel('x(t)')
        set(gca,'XTick',[])

        subplot(212), plot(f, audioOriginalFrequenciaE, 'b'),       
        axis tight, title('Sinal no domínio da Frequência'),
        xlabel('Frequência(Hz)')
        ylabel('Amplitude')
    elseif escolha == 3
        subplot(211), plot(audioJaneladoTempo, 'b'),
        axis tight, title('Sinal Janelado (Tempo)'),
        xlabel('n')
        ylabel('x(t)')
        set(gca,'XTick',[])

        subplot(212), plot(f, audioJaneladoFrequenciaE, 'b'),      
        axis tight, title('Sinal no domínio da Frequência'),
        xlabel('Frequência(Hz)')
        ylabel('Amplitude')
    elseif escolha == 4
        subplot(211), plot(audioOriginalTempo, 'b'),
        axis tight, title('Sinal original (tempo)'),
        xlabel('n')
        ylabel('x(t)')
        set(gca,'XTick',[])
        
        subplot(212), plot(audioJaneladoTempo, 'b'),
        axis tight, title('Sinal janelado (Tempo)'),
        xlabel('n')
        ylabel('g(t)')  
        set(gca,'XTick',[])
    end
    
end
