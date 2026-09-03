# Pedaleira Valeton / Hotone / Sonicake não conecta no PC — ou atualização travada em 0% — no Windows 11?

[🇺🇸 English](README.md) · **Valeton · Hotone · Sonicake · Windows 11**

<p align="center"><b>Baixe um arquivo. Dê dois cliques. Clique em "Sim". Tente de novo.</b></p>

![Atualização de firmware travada em 0% no Windows 11 — solução em um clique para pedaleiras Valeton, Hotone e Sonicake](social-preview.png)

**É o seu caso se qualquer uma dessas coisas está acontecendo:**

- A pedaleira é nova (ou foi ligada num PC novo) e o **Valeton Suite / app da Hotone não enxerga ela**. Sem conexão não dá para passar NAM, IR nem presets, e nem para começar uma atualização de firmware.
- Você conseguiu conectar, iniciou a atualização, e o PC **fica em 0 % e fecha** enquanto a tela da pedaleira diz **"Firmware Update / Restore — Please don't shut down"** — e agora ela não sai mais dessa tela.
- Você seguiu o procedimento oficial da Valeton/Hotone (trocar o driver para *Dispositivo de Áudio USB*), a conexão voltou, **mas a atualização de firmware continua morrendo em 0 %**.

As três coisas são o mesmo problema do **Windows 11** batendo na pedaleira em momentos diferentes. Ela não está com defeito. Nada foi perdido. A correção leva dois minutos, sem baixar driver, sem desinstalar atualização do Windows e sem outro computador — e este arquivo resolve cada um desses momentos.

Isso vale para **todas** as pedaleiras da Valeton (GP-5, GP-50, GP-100, GP-150, GP-180, GP-200, GP-200JR, GP-200LT, GP-300), da Hotone (Ampero, Ampero One, Ampero Mini, Ampero II, II Stomp, II Stage, II XL, Pulze, Pulze Mini, Jogg, UA-12) e da Sonicake (Matribox, Matribox II e II Pro, Pocket Master, Smart Box, Sonic Cube, AMPCUBE). São três marcas da mesma fábrica, com a mesma eletrônica USB, e todas quebram do mesmo jeito.

---

## Resolva agora

**1.** Baixe o arquivo **[`FIX-FIRMWARE-DRIVER.bat`](https://github.com/cesardamien/hotone-family-firmware-fix/releases/latest/download/FIX-FIRMWARE-DRIVER.bat)**. Coloque em qualquer pasta — Downloads serve.

**2.** Conecte a pedaleira pelo USB, no estado em que ela estiver agora:
- *O Suite não enxerga a pedaleira?* Deixe ela em modo normal, ligada.
- *Travada em "Firmware Update / Restore"?* Deixe nessa tela. Não reinicie.
- *A atualização falhou e a pedaleira voltou ao modo normal?* Inicie a atualização de novo pelo Suite até a pedaleira mostrar a tela de atualização, e deixe lá.

**3.** Dê **dois cliques** em `FIX-FIRMWARE-DRIVER.bat`. O Windows vai perguntar *"Deseja permitir que este aplicativo faça alterações no seu dispositivo?"* — clique **Sim**. Se antes disso aparecer uma tela azul do SmartScreen dizendo que o Windows protegeu o computador, clique em *Mais informações* → *Executar assim mesmo* (isso aparece para qualquer arquivo baixado da internet que não tenha assinatura paga).

**4.** Em alguns segundos abre um bloco de notas com o resultado. Procure a palavra **SUCCESS** no final. Aí faça o que estava tentando: abra o Valeton Suite e ele vai enxergar a pedaleira; ou clique em *Firmware Update*, escolha o `.bin` e veja a barra ir até 100 %.

**5.** **Importante — você vai rodar duas vezes.** Corrigir a conexão (modo normal) e corrigir a atualização (tela de atualização) são dois dispositivos diferentes para o Windows. Se você corrigiu a conexão primeiro e depois a atualização parou em 0 %, deixe a pedaleira na tela de atualização e dê dois cliques no arquivo de novo. Essa segunda rodada é a que ninguém documenta.

Se o Windows pedir para reiniciar, escolha *Reiniciar mais tarde* e tente primeiro. Na maioria dos casos funciona na hora.

É só isso. O restante desta página é para quem quer entender o que aconteceu ou está com alguma dúvida.

---

## O que estava errado (explicado sem jargão)

A pedaleira conversa com o programa da Valeton/Hotone por uma conexão MIDI via USB. Até o começo de 2026 o Windows instalava o driver que esse programa espera (o driver genérico de *áudio USB*). Em fevereiro de 2026 a Microsoft lançou um sistema MIDI novo para o Windows 11, e a partir daí o Windows passou a preferir um driver *MIDI* novo para qualquer dispositivo desse tipo. O programa do fabricante não sabe conversar por esse driver novo. Essa única mudança aparece em três camadas, na ordem em que a maioria tromba com elas:

**Camada 1 — a pedaleira não conecta.** Você liga uma pedaleira nova, o Windows instala o driver MIDI novo nela, e o Suite simplesmente não enxerga. Sem NAM, sem IR, sem preset, sem atualização. A Valeton e a Hotone sabem disso e publicaram um aviso: trocar o driver para *Dispositivo de Áudio USB* no Gerenciador de Dispositivos. O aviso está certo — para essa camada.

**Camada 2 — a atualização de firmware para em 0 %.** Quando a pedaleira entra no modo de atualização, ela *vira outro dispositivo* para o Windows — como se você tivesse desconectado e ligado um aparelho que ninguém nunca viu. O Windows instala o driver MIDI novo nesse *segundo* aparelho também, independente do que você fez na camada 1. O atualizador manda o primeiro pacote, não recebe resposta e desiste; a pedaleira fica na tela de atualização esperando. É a parte que o aviso oficial não menciona: a troca de driver precisa ser feita **de novo, com a pedaleira na tela de atualização**. Quem "já fez a correção" trava aqui, convencido de que a correção não funciona.

**Camada 3 — a opção não aparece na lista.** Quando você finalmente abre o Gerenciador com a pedaleira no modo certo, muitas vezes *"Dispositivo de Áudio USB"* **nem é oferecido**, porque o Windows esconde o que ele considera "pior" que o driver novo. A dica oficial de manter marcada a caixa *"Mostrar hardware compatível"* é justamente o que esconde a opção.

O `FIX-FIRMWARE-DRIVER.bat` faz a troca certa, no aparelho que estiver conectado naquele momento, pelo caminho que não depende dessa lista: ele encontra qualquer dispositivo Valeton/Hotone/Sonicake conectado — modo normal ou modo de atualização — e aplica nele o driver de áudio USB que já vem dentro do Windows, usando a mesma função que o Gerenciador de Dispositivos usa por baixo dos panos. Não baixa nada, não instala nada de fora, não toca em mais nenhum dispositivo do seu computador.

---

## Perguntas que sempre aparecem

**Isso é seguro? É um arquivo .bat baixado da internet pedindo administrador.**
Justo. Abra o arquivo no Bloco de Notas: tudo que ele faz está escrito lá, em PowerShell legível, sem nada compactado ou escondido. Ele precisa de administrador porque o Windows exige isso para qualquer troca de driver — o mesmo pedido apareceria se você fizesse a troca manualmente. Ele só enxerga dispositivos com o código de fabricante `84EF` (Valeton/Hotone/Sonicake); o resto do computador não é sequer listado. Se preferir olhar antes de mexer, o `DIAGNOSE-ONLY.bat` mostra o que está conectado e com qual driver, sem alterar nada e sem pedir administrador.

**Vou precisar fazer isso toda vez que atualizar o firmware?**
Provavelmente sim — e duas vezes por atualização, se a conexão também quebrar. O Windows reinstala o driver do "aparelho de atualização" a cada vez, e a cada atualização da Microsoft ele volta a preferir o driver MIDI. Guarde o arquivo. O ritual é sempre o mesmo: pedaleira na tela de atualização → dois cliques → atualizar.

**Isso muda alguma coisa no uso normal da pedaleira? Gravar, tocar, usar o editor?**
Não. Depois da atualização a pedaleira reinicia e volta a ser o "aparelho normal", com o driver de sempre (o ASIO do fabricante ou o do Windows). O driver de áudio USB fica só no "aparelho de atualização", que nada usa fora da hora de atualizar.

**O bloco de notas diz "No VID_84EF device is connected right now".**
A pedaleira não está no modo de atualização, ou o cabo é só de carga. Use o cabo que veio na caixa, ligue direto no PC (sem hub), leve a pedaleira até a tela *Firmware Update / Restore* e rode de novo.

**Deu SUCCESS mas a atualização ainda parou em 0 %.**
Reinicie o Windows, deixe a pedaleira na tela de atualização, rode a atualização de novo. Se ainda assim falhar, troque para uma porta USB-A direto na placa-mãe (traseira do gabinete, ou lateral do notebook, evitando USB-C). Persistindo, abra uma issue aqui com o `firmware-fix-log.txt` que fica na mesma pasta do `.bat` — a gente resolve junto.

**A atualização passou de 100 % e começou outra barra, "BT And PD Updating".**
Normal. Alguns pacotes de firmware atualizam dois chips: o principal e o de Bluetooth/energia. Deixe terminar; a pedaleira reinicia sozinha no final.

**Tenho um Mac / Linux / Windows 10.**
Aí não é esse problema. O driver MIDI novo só existe no Windows 11 atualizado a partir de fevereiro de 2026.

---

## Confirmado onde, esperado onde

Este projeto nasceu de uma **Valeton GP-180** que chegou na V1.0.0, não conectava de jeito nenhum num Windows 11 25H2 atualizado, e depois que a conexão foi resolvida ficou vários dias presa na tela de atualização. As duas camadas foram resolvidas com este método e ela terminou na V1.1.1; está tudo documentado, log incluso ([docs/EXAMPLE-LOG.md](docs/EXAMPLE-LOG.md)).

Nos outros modelos a correção é a mesma por construção: mesmo código de fabricante USB, mesmo modo de atualização por MIDI, mesmo aviso oficial das duas marcas. Mas ainda **não tenho um log de cada um**. Se funcionou na sua — ou não funcionou — abra uma issue com o modelo e o log; leva um minuto e é o que transforma "esperado" em "confirmado" na [tabela de dispositivos](docs/SUPPORTED-DEVICES.md) para a próxima pessoa.

---

## Sintomas que as pessoas pesquisam

Se alguma dessas frases descreve o seu caso, você está no lugar certo: *atualização de firmware Valeton travada em 0%* · *Valeton Suite não atualiza firmware no Windows 11* · *GP-200 / GP-180 / GP-100 presa na tela Firmware Update Restore* · *pedaleira Valeton "please don't shut down" travada* · *Hotone Ampero atualização de firmware falha no Windows 11* · *Ampero II Stomp / Stage atualização travada* · *Sonicake Matribox firmware 0%* · *Dispositivo de Áudio USB não aparece na lista de drivers* · *Valeton instala driver MIDI em vez de áudio USB* · *Windows 11 usbmidi2 bootloader* · *Valeton GP-180 brickou depois da atualização* (não brickou — rode a correção e atualize de novo) · *Valeton Suite não reconhece a pedaleira* · *GP-180 não conecta no PC* · *não consigo passar NAM para a Valeton* · *Ampero não é reconhecida no Windows 11*.

English: *Valeton firmware update stuck at 0%* · *Hotone Ampero firmware update fails Windows 11* · *USB Audio Device not in driver list*.

Español: *Valeton actualización de firmware se queda en 0%* · *Hotone Ampero actualización firmware Windows 11 no funciona* · *pedalera bloqueada en Firmware Update Restore*.

---

## Arquivos deste repositório

`FIX-FIRMWARE-DRIVER.bat` é o único arquivo que você precisa: o script inteiro está dentro dele. `DIAGNOSE-ONLY.bat` é opcional, só olha e não muda nada (precisa estar na mesma pasta do primeiro). `source/Fix-FirmwareDriver.ps1` é o mesmo script como arquivo PowerShell separado, para quem quer ler ou rodar direto. `docs/` tem a lista de dispositivos e o log real de exemplo.

Feito por Cesar Damien, com análise e código desenvolvidos junto com o Claude (Anthropic), depois de uma GP-180 novinha passar dias na tela de atualização. Sem vínculo com Valeton, Hotone, Sonicake ou Microsoft. Referências: [aviso da Valeton](https://www.valeton.net/win11-technical-notice/), [aviso da Hotone](https://www.hotone.cl/actualizacion-de-firmware-en-windows-11/), [artigo da Sweetwater](https://www.sweetwater.com/sweetcare/articles/valeton-gp-series-firmware-update-fix-on-windows-11/), [anúncio do Windows MIDI Services](https://blogs.windows.com/windowsexperience/2026/02/17/making-music-with-midi-just-got-a-real-boost-in-windows-11/), [relato do mesmo problema para a Microsoft](https://github.com/microsoft/MIDI/issues/944). Licença MIT — use, copie, melhore.
