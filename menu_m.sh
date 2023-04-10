#!/usr/bin/env bash

##### INCLUDES #####################################################################################################
#source /home/tc/menufunc.h
#####################################################################################################

TMP_PATH=/tmp
LOG_FILE="${TMP_PATH}/log.txt"
USER_CONFIG_FILE="/home/tc/user_config.json"

MODEL=$(jq -r -e '.general.model' "$USER_CONFIG_FILE")
BUILD=$(jq -r -e '.general.version' "$USER_CONFIG_FILE" | cut -c 7-)
SN=$(jq -r -e '.extra_cmdline.sn' "$USER_CONFIG_FILE")
MACADDR1=$(jq -r -e '.extra_cmdline.mac1' "$USER_CONFIG_FILE")
NETNUM="1"

LAYOUT=$(jq -r -e '.general.layout' "$USER_CONFIG_FILE")
KEYMAP=$(jq -r -e '.general.keymap' "$USER_CONFIG_FILE")

DMPM=$(jq -r -e '.general.devmod' "$USER_CONFIG_FILE")
LDRMODE=$(jq -r -e '.general.loadermode' "$USER_CONFIG_FILE")
ucode=$(jq -r -e '.general.ucode' "$USER_CONFIG_FILE")

### Messages Contents
## US
MSGUS00="Device-Tree[DT] Base Models & HBAs do not require SataPortMap,DiskIdxMap\nDT models do not support HBAs\n"
MSGUS01="Choose a Dev Mod handling method, DDSML/EUDEV"
MSGUS02="Choose a Synology Model"
MSGUS03="Choose a Synology Serial Number"
MSGUS04="Choose a mac address"
MSGUS05="Build the [TCRP JOT Mode] loader"
MSGUS06="Choose a loader Mode Current "
MSGUS07="Build the [TCRP 7.1.1-42962] loader"
MSGUS08="Build the [TCRP 7.0.1-42218] loader (FRIEND)"
MSGUS09="Post Update for [TCRP JOT Mod]"
MSGUS10="Edit user config file manually"
MSGUS11="Choose a keymap"
MSGUS12="Erase Data DISK"
MSGUS13="Backup TCRP"
MSGUS14="Reboot"
MSGUS15="Exit"
MSGUS16="Max 24 Threads, any x86-64"
MSGUS17="Max 8 Threads, Haswell or later,iGPU Transcoding"
MSGUS18="HBA displays incorrect disk S/N"
MSGUS19="(DT,AMD Ryzen)"
MSGUS20="Max ? Threads, any x86-64"
MSGUS21="Have a camera license"
MSGUS22="Max 16 Threads, any x86-64"
MSGUS23="Max 16 Threads, Haswell or later"
MSGUS24="Nvidia GTX1650"
MSGUS25="Nvidia GTX1050Ti"
MSGUS26="EUDEV (enhanced user-space device)"
MSGUS27="DDSML (Detected Device Static Module Loading)"
MSGUS28="FRIEND (most recently stabilized)"
MSGUS29="JOT (The old way before friend)"
MSGUS30="Generate a random serial number"
MSGUS31="Enter a serial number"
MSGUS32="Get a real mac address"
MSGUS33="Generate a random mac address"
MSGUS34="Enter a mac address"
MSGUS35="press any key to continue..."
MSGUS36="Synology serial number not set. Check user_config.json again. Abort the loader build !!!!!!"
MSGUS37="The first MAC address is not set. Check user_config.json again. Abort the loader build !!!!!!"
MSGUS38="The netif_num and the number of mac addresses do not match. Check user_config.json again. Abort the loader build !!!!!!"
MSGUS39="Choose a lageuage"
MSGUS40="DDSML+EUDEV"

## RU
MSGRU00="Базовые модели и HBAs Device-Tree [DT] не требуют SataPortMap, DiskIdxMap \nDT модели не поддерживают HBAs\n"
MSGRU01="Выберите метод обработки Dev Mod, DDSML/EUDEV"
MSGRU02="Выберите модель Synology"
MSGRU03="Выберите серийный номер Synology"
MSGRU04="Выберите MAC-адрес"
MSGRU05="Соберите загрузчик [TCRP JOT Mode]"
MSGRU06="Выберите текущий режим загрузчика"
MSGRU07="Соберите загрузчик [TCRP 7.1.1-42962]"
MSGRU08="Соберите загрузчик [TCRP 7.0.1-42218] (FRIEND)"
MSGRU09="После обновления для [TCRP JOT Mod]"
MSGRU10="Отредактируйте файл конфигурации пользователя вручную"
MSGRU11="Выберите раскладку клавиатуры"
MSGRU12="Стереть данные с диска"
MSGRU13="Резервное копирование TCRP"
MSGRU14="Перезагрузить"
MSGRU15="Выход"
MSGRU16="Максимум 24 потока, любой x86-64"
MSGRU17="Максимум 8 потоков, Haswell или более поздний, iGPU транскодирование"
MSGRU18="HBA отображает неправильный серийный номер диска"
MSGRU19="(DT, AMD Ryzen)"
MSGRU20="Максимум ? Потоки, любой x86-64"
MSGRU21="Есть ли лицензия на камеру"
MSGRU22="Максимум 16 потоков, любой x86-64"
MSGRU23="Максимум 16 потоков, Haswell или более поздний"
MSGRU24="Nvidia GTX1650"
MSGRU25="Nvidia GTX1050Ti"
MSGRU26="EUDEV (усовершенствованное устройство пользовательского пространства)"
MSGRU27="DDSML (Загрузка статического модуля обнаруженного устройства)"
MSGRU28="FRIEND (недавно стабилизированный)"
MSGRU29="JOT (Старый способ до friend)"
MSGRU30="Сгенерировать случайный серийный номер"
MSGRU31="Введите серийный номер"
MSGRU32="Получить реальный MAC-адрес"
MSGRU33="Сгенерировать случайный MAC-адрес"
MSGRU34="Введите MAC-адрес"
MSGRU35="нажмите любую клавишу для продолжения ..."
MSGRU36="Серийный номер Synology не задан. Проверьте файл user_config.json еще раз. Остановка построения загрузчика !!!!"
MSGRU37="Первый MAC-адрес не задан. Проверьте файл user_config.json еще раз. Остановка построения загрузчика !!!!!!"
MSGRU38="Количество интерфейсов (netif_num) и количество MAC-адресов не совпадают. Проверьте файл user_config.json еще раз. Остановка построения загрузчика !!!!!!"
MSGRU39="Выберите язык"
MSGRU40="DDSML+EUDEV"

## FR
MSGFR00="Les modèles de base et les HBAs de l'arbre de périphériques [DT] ne nécessitent pas de SataPortMap, DiskIdxMap\nLes modèles DT ne prennent pas en charge les HBAs\n"
MSGFR01="Choisissez une méthode de gestion des modèles de périphérique, DDSML/EUDEV"
MSGFR02="Choisissez un modèle Synology"
MSGFR03="Choisissez un numéro de série Synology"
MSGFR04="Choisissez une adresse MAC"
MSGFR05="Construisez le chargeur [TCRP JOT Mode]"
MSGFR06="Choisissez un mode de chargeur actuel"
MSGFR07="Construisez le chargeur [TCRP 7.1.1-42962]"
MSGFR08="Construisez le chargeur [TCRP 7.0.1-42218] (FRIEND)"
MSGFR09="Post-Update pour [TCRP JOT Mod]"
MSGFR10="Modifier manuellement le fichier de configuration de l'utilisateur"
MSGFR11="Choisissez une disposition de clavier"
MSGFR12="Effacer le disque de données"
MSGFR13="Sauvegarde TCRP"
MSGFR14="Redémarrer"
MSGFR15="Sortie"
MSGFR16="Max 24 Threads, n'importe quel x86-64"
MSGFR17="Max 8 Threads, Haswell ou plus tard, transcodage iGPU"
MSGFR18="L'HBA affiche un S/N de disque incorrect"
MSGFR19="(DT, AMD Ryzen)"
MSGFR20="Max ? Threads, n'importe quel x86-64"
MSGFR21="Avoir une licence de caméra"
MSGFR22="Max 16 Threads, n'importe quel x86-64"
MSGFR23="Max 16 Threads, Haswell ou plus tard"
MSGFR24="Nvidia GTX1650"
MSGFR25="Nvidia GTX1050Ti"
MSGFR26="EUDEV (périphérique d'espace utilisateur amélioré)"
MSGFR27="DDSML (Chargement de module statique de périphérique détecté)"
MSGFR28="FRIEND (le plus récemment stabilisé)"
MSGFR29="JOT (l'ancienne méthode avant friend)"
MSGFR30="Générer un numéro de série aléatoire"
MSGFR31="Entrez un numéro de série"
MSGFR32="Obtenir une véritable adresse MAC"
MSGFR33="Générer une adresse MAC aléatoire"
MSGFR34="Entrez une adresse MAC"
MSGFR35="appuyez sur n'importe quelle touche pour continuer..."
MSGFR36="Le numéro de série Synology n'est pas défini. Vérifiez à nouveau user_config.json. Abandonner la construction du chargeur !!!!!!"
MSGFR37="La première adresse MAC n'est pas définie. Vérifiez à nouveau user_config.json. Abandonner la construction du chargeur !!!!!!"
MSGFR38="Le netif_num et le nombre d'adresses MAC ne correspondent pas. Vérifiez à nouveau user_config.json. Abandonner la construction du chargeur !!!!!!"
MSGFR39="Choisissez une langue"
MSGFR40="DDSML+EUDEV"

## DE
MSGDE00="Gerätebaum[DT] Basismodelle und HBAs benötigen kein SataPortMap,DiskIdxMap\nDT-Modelle unterstützen keine HBAs\n"
MSGDE01="Wählen Sie eine Methode zur Verwaltung von Dev-Mods, DDSML/EUDEV"
MSGDE02="Wählen Sie ein Synology-Modell"
MSGDE03="Wählen Sie eine Synology-Seriennummer"
MSGDE04="Wählen Sie eine MAC-Adresse"
MSGDE05="Erstellen Sie den [TCRP JOT-Modus] Loader"
MSGDE06="Wählen Sie einen Loader-Modus Current"
MSGDE07="Erstellen Sie den [TCRP 7.1.1-42962] Loader"
MSGDE08="Erstellen Sie den [TCRP 7.0.1-42218] Loader (FRIEND)"
MSGDE09="Post-Update für [TCRP JOT-Mod]"
MSGDE10="Bearbeiten Sie die Benutzerkonfigurationsdatei manuell"
MSGDE11="Wählen Sie eine Tastenkarte"
MSGDE12="Löschen Sie die Datendiskette"
MSGDE13="Backup TCRP"
MSGDE14="Neu starten"
MSGDE15="Beenden"
MSGDE16="Max. 24 Threads, beliebiges x86-64"
MSGDE17="Max. 8 Threads, Haswell oder höher, iGPU-Transcodierung"
MSGDE18="HBA zeigt falsche Festplattenseriennummer an"
MSGDE19="(DT,AMD Ryzen)"
MSGDE20="Max. ? Threads, beliebiges x86-64"
MSGDE21="Haben Sie eine Kamera-Lizenz"
MSGDE22="Max. 16 Threads, beliebiges x86-64"
MSGDE23="Max. 16 Threads, Haswell oder höher"
MSGDE24="Nvidia GTX1650"
MSGDE25="Nvidia GTX1050Ti"
MSGDE26="EUDEV (verbessertes Benutzerraumgerät)"
MSGDE27="DDSML (Erkannte Gerätestatische Modulladung)"
MSGDE28="FRIEND (zuletzt stabilisiert)"
MSGDE29="JOT (Der alte Weg vor Freund)"
MSGDE30="Erstellen Sie eine zufällige Seriennummer"
MSGDE31="Geben Sie eine Seriennummer ein"
MSGDE32="Holen Sie sich eine echte MAC-Adresse"
MSGDE33="Erstellen Sie eine zufällige MAC-Adresse"
MSGDE34="Geben Sie eine MAC-Adresse ein"
MSGDE35="Drücken Sie eine beliebige Taste, um fortzufahren..."
MSGDE36="Synology-Seriennummer nicht festgelegt. Überprüfen Sie user_config.json erneut. Loader-Build abbrechen !!!!!!"
MSGDE37="Die erste MAC-Adresse ist nicht festgelegt. Überprüfen Sie user_config.json erneut. Loader-Build abbrechen !!!!!!"
MSGDE38="Die netif_num und die Anzahl der MAC-Adressen stimmen nicht überein. Überprüfen Sie user_config.json erneut. Loader-Build abbrechen !!!!!!"
MSGDE39="Wählen Sie eine Sprache"
MSGDE40="DDSML+EUDEV"

## ES

MSGES00="Los modelos base y HBAs de Device-Tree[DT] no requieren SataPortMap, DiskIdxMap\nLos modelos DT no admiten HBAs\n"
MSGES01="Elija un método de manejo de Mod Dev, DDSML/EUDEV"
MSGES02="Elija un modelo de Synology"
MSGES03="Elija un número de serie de Synology"
MSGES04="Elija una dirección MAC"
MSGES05="Construir el cargador [TCRP JOT Mode]"
MSGES06="Elija un modo de cargador Actual"
MSGES07="Construir el cargador [TCRP 7.1.1-42962]"
MSGES08="Construir el cargador [TCRP 7.0.1-42218] (FRIEND)"
MSGES09="Actualización posterior para [TCRP JOT Mod]"
MSGES10="Editar manualmente el archivo de configuración del usuario"
MSGES11="Elija un mapa de teclas"
MSGES12="Borrar disco de datos"
MSGES13="Copia de seguridad de TCRP"
MSGES14="Reiniciar"
MSGES15="Salir"
MSGES16="Máx. 24 hilos, cualquier x86-64"
MSGES17="Máx. 8 hilos, Haswell o posterior, transcodificación de iGPU"
MSGES18="HBA muestra el S/N incorrecto del disco"
MSGES19="(DT,AMD Ryzen)"
MSGES20="Máx. ? hilos, cualquier x86-64"
MSGES21="Tener una licencia de cámara"
MSGES22="Máx. 16 hilos, cualquier x86-64"
MSGES23="Máx. 16 hilos, Haswell o posterior"
MSGES24="Nvidia GTX1650"
MSGES25="Nvidia GTX1050Ti"
MSGES26="EUDEV (dispositivo de espacio de usuario mejorado)"
MSGES27="DDSML (Carga de módulo estático de dispositivo detectado)"
MSGES28="FRIEND (estabilizado más recientemente)"
MSGES29="JOT (La forma antigua antes de friend)"
MSGES30="Generar un número de serie aleatorio"
MSGES31="Ingrese un número de serie"
MSGES32="Obtener una dirección MAC real"
MSGES33="Generar una dirección MAC aleatoria"
MSGES34="Ingrese una dirección MAC"
MSGES35="Presione cualquier tecla para continuar..."
MSGES36="Número de serie de Synology no establecido. Revise user_config.json nuevamente. ¡¡¡¡Abortar la construcción del cargador!!!!"
MSGES37="La primera dirección MAC no está establecida. Revise user_config.json nuevamente. ¡¡¡¡Abortar la construcción del cargador!!!!"
MSGES38="El número de netif_num y direcciones MAC no coinciden. Revise user_config.json nuevamente. ¡¡¡¡Abortar la construcción del cargador!!!!"
MSGES39="Elige un idioma"
MSGES40="DDSML+EUDEV"

## BR

MSGBR00="Modelos Base e HBAs do Device-Tree[DT] não requerem SataPortMap, DiskIdxMap\nModelos DT não suportam HBAs\n"
MSGBR01="Escolha um método de manipulação de Dev Mod, DDSML/EUDEV"
MSGBR02="Escolha um modelo Synology"
MSGBR03="Escolha um número de série Synology"
MSGBR04="Escolha um endereço MAC"
MSGBR05="Construa o loader [TCRP JOT Mode]"
MSGBR06="Escolha o modo de loader Atual"
MSGBR07="Construa o loader [TCRP 7.1.1-42962]"
MSGBR08="Construa o loader [TCRP 7.0.1-42218] (FRIEND)"
MSGBR09="Atualização pós [TCRP JOT Mod]"
MSGBR10="Edite manualmente o arquivo de configuração do usuário"
MSGBR11="Escolha um mapa de teclado"
MSGBR12="Apague o DISK de dados"
MSGBR13="Backup TCRP"
MSGBR14="Reinicie"
MSGBR15="Sair"
MSGBR16="Máximo de 24 Threads, qualquer x86-64"
MSGBR17="Máximo de 8 Threads, Haswell ou posterior, transcoding de iGPU"
MSGBR18="HBA exibe S/N de disco incorreto"
MSGBR19="(DT,AMD Ryzen)"
MSGBR20="Máximo de ? Threads, qualquer x86-64"
MSGBR21="Ter uma licença de câmera"
MSGBR22="Máximo de 16 Threads, qualquer x86-64"
MSGBR23="Máximo de 16 Threads, Haswell ou posterior"
MSGBR24="Nvidia GTX1650"
MSGBR25="Nvidia GTX1050Ti"
MSGBR26="EUDEV (dispositivo de usuário aprimorado)"
MSGBR27="DDSML (Carregamento de Módulo Estático de Dispositivo Detectado)"
MSGBR28="FRIEND (mais recentemente estabilizado)"
MSGBR29="JOT (O antigo método antes de friend)"
MSGBR30="Gerar um número de série aleatório"
MSGBR31="Digite um número de série"
MSGBR32="Obter um endereço MAC real"
MSGBR33="Gerar um endereço MAC aleatório"
MSGBR34="Digite um endereço MAC"
MSGBR35="pressione qualquer tecla para continuar..."
MSGBR36="Número de série Synology não definido. Verifique o user_config.json novamente. Abortar a construção do loader!!!!!!"
MSGBR37="O primeiro endereço MAC não está definido. Verifique o user_config.json novamente. Abortar a construção do loader!!!!!!"
MSGBR38="O netif_num e o número de endereços MAC não correspondem. Verifique o user_config.json novamente. Abortar a construção do loader!!!!!!"
MSGBR39="Olá! Posso ajudá-lo em Português"
MSGBR40="DDSML+EUDEV"

## IT

MSGIT00="I modelli di base e gli HBA di Device-Tree [DT] non richiedono SataPortMap, DiskIdxMap\nI modelli DT non supportano gli HBA\n"
MSGIT01="Scegli un metodo di gestione del Mod Dev, DDSML/EUDEV"
MSGIT02="Scegli un modello Synology"
MSGIT03="Scegli un numero di serie Synology"
MSGIT04="Scegli un indirizzo MAC"
MSGIT05="Costruisci il caricatore [TCRP JOT Mode]"
MSGIT06="Scegli una modalità di caricatore corrente"
MSGIT07="Costruisci il caricatore [TCRP 7.1.1-42962]"
MSGIT08="Costruisci il caricatore [TCRP 7.0.1-42218] (FRIEND)"
MSGIT09="Post Update per [TCRP JOT Mod]"
MSGIT10="Modifica manualmente il file di configurazione dell'utente"
MSGIT11="Scegli una mappatura dei tasti"
MSGIT12="Cancella il disco dati"
MSGIT13="Backup TCRP"
MSGIT14="Riavvia"
MSGIT15="Esci"
MSGIT16="Max 24 Thread, qualsiasi x86-64"
MSGIT17="Max 8 Thread, Haswell o successivi, trascodifica iGPU"
MSGIT18="HBA visualizza il numero di serie del disco in modo errato"
MSGIT19="(DT, AMD Ryzen)"
MSGIT20="Max ? Thread, qualsiasi x86-64"
MSGIT21="Hai una licenza per la telecamera"
MSGIT22="Max 16 Thread, qualsiasi x86-64"
MSGIT23="Max 16 Thread, Haswell o successivi"
MSGIT24="Nvidia GTX1650"
MSGIT25="Nvidia GTX1050Ti"
MSGIT26="EUDEV (dispositivo a spazio utente migliorato)"
MSGIT27="DDSML (Caricamento statico del modulo dispositivo rilevato)"
MSGIT28="FRIEND (più recentemente stabilizzato)"
MSGIT29="JOT (il vecchio modo prima di FRIEND)"
MSGIT30="Genera un numero di serie casuale"
MSGIT31="Inserisci un numero di serie"
MSGIT32="Ottieni un vero indirizzo MAC"
MSGIT33="Genera un indirizzo MAC casuale"
MSGIT34="Inserisci un indirizzo MAC"
MSGIT35="premere un tasto per continuare..."
MSGIT36="Numero di serie Synology non impostato. Controlla di nuovo user_config.json. Abortire la costruzione del caricatore !!!!!!"
MSGIT37="Il primo indirizzo MAC non è impostato. Controlla di nuovo user_config.json. Abortire la costruzione del caricatore !!!!!!"
MSGIT38="Il numero di netif e il numero di indirizzi MAC non corrispondono. Controlla di nuovo user_config.json. Abortire la costruzione del caricatore !!!!!!"
MSGIT39="Scegli una lingua"
MSGIT40="DDSML+EUDEV"

## KR
MSGKR00="Device-Tree[DT]모델과 HBA는 SataPortMap,DiskIdxMap 설정이 필요없습니다.\nDT모델은 HBA를 지원하지 않습니다.\n"
MSGKR01="커널모듈 처리방법 선택 DDSML/EUDEV"
MSGKR02="Synology 모델 선택"
MSGKR03="Synology S/N 선택"
MSGKR04="선택 Mac 주소 "
MSGKR05="[TCRP JOT Mode] 로더 빌드"
MSGKR06="로더모드 선택 현재"
MSGKR07="[TCRP 7.1.1-42962] 로더 빌드"
MSGKR08="[TCRP 7.0.1-42218] 로더 빌드 (FRIEND)"
MSGKR09="[TCRP JOT 모드]용 Post 업데이트"
MSGKR10="user_config.json 파일 편집"
MSGKR11="다국어 자판 지원용 키맵 선택"
MSGKR12="디스크 데이터 지우기"
MSGKR13="TCRP 백업"
MSGKR14="재부팅"
MSGKR15="종료"
MSGKR16="최대 24 스레드 지원, 인텔 x86-64"
MSGKR17="최대 8 스레드 지원, 인텔 4세대 하스웰 이후부터 지원,iGPU H/W 트랜스코딩"
MSGKR18="HBA 사용시 잘못된 디스크 S/N이 표시됨"
MSGKR19="(DT,AMD 라이젠)"
MSGKR20="최대 ? 스레드 지원, 인텔 x86-64"
MSGKR21="카메라 라이센스 있음"
MSGKR22="최대 16 스레드 지원, 인텔 x86-64"
MSGKR23="최대 16 스레드 지원, 인텔 4세대 하스웰 이후부터 지원"
MSGKR24="Nvidia GTX1650 H/W 가속지원"
MSGKR25="Nvidia GTX1050Ti H/W 가속지원"
MSGKR26="EUDEV (향상된 사용자 공간 장치)"
MSGKR27="DDSML (감지된 장치 정적 모듈 로드)"
MSGKR28="FRIEND (가장 최근에 안정화된 로더모드)"
MSGKR29="JOT (FRIEND 보다 옛날 로더모드)"
MSGKR30="시놀로지 랜덤 S/N 생성"
MSGKR31="시놀로지 S/N을 입력하세요"
MSGKR32="실제 MAC 주소 가져오기"
MSGKR33="랜덤 MAC 주소 생성"
MSGKR34="시놀로지 MAC 주소를 입력하세요"
MSGKR35="계속하려면 아무 키나 누르십시오..."
MSGKR36="Synology 일련 번호가 설정되지 않았습니다. user_config.json을 다시 확인하십시오. 로더 빌드를 중단합니다!!!!!!"
MSGKR37="첫 번째 MAC 주소가 설정되지 않았습니다. user_config.json을 다시 확인하십시오. 로더 빌드를 중단합니다!!!!!!"
MSGKR38="netif_num과 mac 주소 갯수가 일치하지 않습니다. user_config.json을 다시 확인하십시오. 로더 빌드를 중단합니다!!!!!!"
MSGKR39="언어를 선택하세요"
MSGKR40="DDSML+EUDEV"

## CN
MSGCN00="设备树[DT]基本型号和HBA不需要SataPortMap、DiskIdxMap\nDT模型不支持HBA\n"
MSGCN01="选择Dev Mod处理方法，DDSML/EUDEV"
MSGCN02="选择一个Synology型号"
MSGCN03="选择一个Synology序列号"
MSGCN04="选择一个mac地址"
MSGCN05="构建[TCRP JOT模式]加载器"
MSGCN06="选择加载器模式 Current"
MSGCN07="构建[TCRP 7.1.1-42962]加载器"
MSGCN08="构建[TCRP 7.0.1-42218]加载器 (FRIEND)"
MSGCN09="[TCRP JOT Mod]后更新"
MSGCN10="手动编辑用户配置文件"
MSGCN11="选择一个键盘映射"
MSGCN12="擦除数据磁盘"
MSGCN13="备份TCRP"
MSGCN14="重新启动"
MSGCN15="退出"
MSGCN16="最大24线程，任何x86-64"
MSGCN17="最大8线程，Haswell或更高版本，iGPU转码"
MSGCN18="HBA显示不正确的磁盘S/N"
MSGCN19="(DT, AMD Ryzen)"
MSGCN20="最大？线程，任何x86-64"
MSGCN21="拥有摄像机许可证"
MSGCN22="最大16线程，任何x86-64"
MSGCN23="最大16线程，Haswell或更高版本"
MSGCN24="Nvidia GTX1650"
MSGCN25="Nvidia GTX1050Ti"
MSGCN26="EUDEV（增强的用户空间设备）"
MSGCN27="DDSML（检测到的设备静态模块加载）"
MSGCN28="FRIEND（最近稳定）"
MSGCN29="JOT（在friend之前的旧方式）"
MSGCN30="生成一个随机序列号"
MSGCN31="输入序列号"
MSGCN32="获取真实的mac地址"
MSGCN33="生成一个随机的mac地址"
MSGCN34="输入mac地址"
MSGCN35="按任意键继续..."
MSGCN36="未设置Synology序列号。请再次检查user_config.json。终止加载器构建!!!!!!"
MSGCN37="未设置第一个MAC地址。请再次检查user_config.json。终止加载器构建!!!!!!"
MSGCN38="netif_num和mac地址数量不匹配。请再次检查user_config.json。终止加载器构建!!!!!!"
MSGCN39="选择语言"
MSGCN40="DDSML+EUDEV"

## JP
MSGJP00="Device-Tree[DT]ベースモデルとHBAsは、SataPortMap、DiskIdxMapが必要ありません\nDTモデルはHBAsをサポートしていません\n"
MSGJP01="Dev Mod処理方法を選択してください、EUDEV / DDSML"
MSGJP02="Synologyモデルを選択してください"
MSGJP03="Synologyシリアル番号を選択してください"
MSGJP04="MACアドレスを選択してください"
MSGJP05="[TCRP JOT Mode]ローダーをビルドする"
MSGJP06="現在のローダーモードを選択してください"
MSGJP07="[TCRP 7.1.1-42962]ローダーをビルドする"
MSGJP08="[TCRP 7.0.1-42218]ローダーをビルドする（FRIEND）"
MSGJP09="[TCRP JOT Mod]のアップデートを投稿する"
MSGJP10="ユーザー設定ファイルを手動で編集する"
MSGJP11="キーマップを選択してください"
MSGJP12="データDISKを消去する"
MSGJP13="TCRPをバックアップする"
MSGJP14="再起動"
MSGJP15="終了"
MSGJP16="最大24スレッド、任意のx86-64"
MSGJP17="Haswell以降、iGPUトランスコーディングを備えた最大8スレッド"
MSGJP18="HBAは間違ったディスクS / Nを表示します"
MSGJP19="(DT、AMD Ryzen)"
MSGJP20="最大？スレッド、任意のx86-64"
MSGJP21="カメラライセンスを持っています"
MSGJP22="最大16スレッド、任意のx86-64"
MSGJP23="Haswell以降、最大16スレッド"
MSGJP24="Nvidia GTX1650"
MSGJP25="Nvidia GTX1050Ti"
MSGJP26="EUDEV（拡張ユーザースペースデバイス）"
MSGJP27="DDSML（検出されたデバイス静的モジュールローディング）"
MSGJP28="FRIEND（最近安定化されました）"
MSGJP29="JOT（フレンドよりも古い方法）"
MSGJP30="ランダムなシリアル番号を生成する"
MSGJP31="シリアル番号を入力してください"
MSGJP32="実際のMACアドレスを取得する"
MSGJP33="ランダムなMACアドレスを生成する"
MSGJP34="MACアドレスを入力してください"
MSGJP35="続行するには任意のキーを押してください..."
MSGJP36="Synologyのシリアル番号が設定されていません。user_config.jsonを再度確認してください。ローダービルドを中止します！！！！"
MSGJP37="最初のMACアドレスが設定されていません。user_config.jsonを再度確認してください。ローダービルドを中止します！！！！"
MSGJP38="netif_numとMACアドレスの数が一致しません。user_config.jsonを再度確認してください。ローダービルドを中止します！！！！"
MSGJP39="言語を選択してください"
MSGJP40="DDSML+EUDEV"

###############################################################################
# check VM or baremetal
function checkmachine() {

    if grep -q ^flags.*\ hypervisor\  /proc/cpuinfo; then
        MACHINE="VIRTUAL"
        HYPERVISOR=$(dmesg | grep -i "Hypervisor detected" | awk '{print $5}')
        echo "Machine is $MACHINE Hypervisor=$HYPERVISOR"
    fi
    
    if [ $(lspci -nn | grep -ie "\[0107\]" | wc -l) -gt 0 ]; then
        echo "Found SAS HBAs, Restrict use of DT Models."
        HBADETECT="ON"
    else
        HBADETECT="OFF"    
    fi    

}

###############################################################################
# check Intel or AMD
function checkcpu() {

    if [ $(lscpu |grep Intel |wc -l) -gt 0 ]; then
        CPU="INTEL"
    else
        if [ $(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//' | grep -e N36L -e N40L -e N54L | wc -l) -gt 0 ]; then
	    CPU="HP"
            LDRMODE="JOT"
            writeConfigKey "general" "loadermode" "${LDRMODE}"          
	else
            CPU="AMD"
        fi	    
    fi

    threads="$(lscpu |grep CPU\(s\): | awk '{print $2}')"
    
    if [ $(lscpu |grep movbe |wc -l) -gt 0 ]; then    
        AFTERHASWELL="ON"
    else
        AFTERHASWELL="OFF"
    fi
    
    if [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "KVM" ]; then
        AFTERHASWELL="ON"    
    fi

}

###############################################################################
# Write to json config file
function writeConfigKey() {

    block="$1"
    field="$2"
    value="$3"

    if [ -n "$1 " ] && [ -n "$2" ]; then
        jsonfile=$(jq ".$block+={\"$field\":\"$value\"}" $USER_CONFIG_FILE)
        echo $jsonfile | jq . >$USER_CONFIG_FILE
    else
        echo "No values to update"
    fi

}

###############################################################################
# Delete field from json config file
function DeleteConfigKey() {

    block="$1"
    field="$2"

    if [ -n "$1 " ] && [ -n "$2" ]; then
        jsonfile=$(jq "del(.$block.$field)" $USER_CONFIG_FILE)
        echo $jsonfile | jq . >$USER_CONFIG_FILE
    else
        echo "No values to remove"
    fi

}


###############################################################################
# Mounts backtitle dynamically
function backtitle() {
  BACKTITLE="TCRP 0.9.4.3-1"
  BACKTITLE+=" ${DMPM}"
  BACKTITLE+=" ${ucode}"
  BACKTITLE+=" ${LDRMODE}"
  if [ -n "${MODEL}" ]; then
    BACKTITLE+=" ${MODEL}"
  else
    BACKTITLE+=" (no model)"
  fi
  if [ -n "${BUILD}" ]; then
    BACKTITLE+=" ${BUILD}"
  else
    BACKTITLE+=" (no build)"
  fi
  if [ -n "${SN}" ]; then
    BACKTITLE+=" ${SN}"
  else
    BACKTITLE+=" (no SN)"
  fi
  if [ -n "${IP}" ]; then
    BACKTITLE+=" ${IP}"
  else
    BACKTITLE+=" (no IP)"
  fi
  if [ -n "${MACADDR1}" ]; then
    BACKTITLE+=" ${MACADDR1}"
  else
    BACKTITLE+=" (no MAC1)"
  fi
  if [ -n "${MACADDR2}" ]; then
    BACKTITLE+=" ${MACADDR2}"
  else
    BACKTITLE+=" (no MAC2)"
  fi
  if [ -n "${MACADDR3}" ]; then
    BACKTITLE+=" ${MACADDR3}"
  else
    BACKTITLE+=" (no MAC3)"
  fi
  if [ -n "${MACADDR4}" ]; then
    BACKTITLE+=" ${MACADDR4}"
  else
    BACKTITLE+=" (no MAC4)"
  fi
  if [ -n "${KEYMAP}" ]; then
    BACKTITLE+=" (${LAYOUT}/${KEYMAP})"
  else
    BACKTITLE+=" (qwerty/us)"
  fi
  echo ${BACKTITLE}
}

###############################################################################
# identify usb's pid vid
function usbidentify() {

    checkmachine

    if [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "VMware" ]; then
        echo "Running on VMware, no need to set USB VID and PID, you should SATA shim instead"
    elif [ "$MACHINE" = "VIRTUAL" ] && [ "$HYPERVISOR" = "QEMU" ]; then
        echo "Running on QEMU, If you are using USB shim, VID 0x46f4 and PID 0x0001 should work for you"
        vendorid="0x46f4"
        productid="0x0001"
        echo "Vendor ID : $vendorid Product ID : $productid"
        json="$(jq --arg var "$productid" '.extra_cmdline.pid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
        json="$(jq --arg var "$vendorid" '.extra_cmdline.vid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
    else            
    
        loaderdisk=$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)

        lsusb -v 2>&1 | grep -B 33 -A 1 SCSI >/tmp/lsusb.out

        usblist=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out)
        vendorid=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out | grep -i idVendor | awk '{print $2}')
        productid=$(grep -B 33 -A 1 SCSI /tmp/lsusb.out | grep -i idProduct | awk '{print $2}')

        if [ $(echo $vendorid | wc -w) -gt 1 ]; then
            echo "Found more than one USB disk devices, please select which one is your loader on"
            usbvendor=$(for item in $vendorid; do grep $item /tmp/lsusb.out | awk '{print $3}'; done)
            select usbdev in $usbvendor; do
                vendorid=$(grep -B 10 -A 10 $usbdev /tmp/lsusb.out | grep idVendor | grep $usbdev | awk '{print $2}')
                productid=$(grep -B 10 -A 10 $usbdev /tmp/lsusb.out | grep -A 1 idVendor | grep idProduct | awk '{print $2}')
                echo "Selected Device : $usbdev , with VendorID: $vendorid and ProductID: $productid"
                break
            done
        else
            usbdevice="$(grep iManufacturer /tmp/lsusb.out | awk '{print $3}') $(grep iProduct /tmp/lsusb.out | awk '{print $3}') SerialNumber: $(grep iSerial /tmp/lsusb.out | awk '{print $3}')"
        fi

        if [ -n "$usbdevice" ] && [ -n "$vendorid" ] && [ -n "$productid" ]; then
            echo "Found $usbdevice"
            echo "Vendor ID : $vendorid Product ID : $productid"
            json="$(jq --arg var "$productid" '.extra_cmdline.pid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
            json="$(jq --arg var "$vendorid" '.extra_cmdline.vid = $var' user_config.json)" && echo -E "${json}" | jq . >user_config.json
        else
            echo "Sorry, no usb disk could be identified"
            rm /tmp/lsusb.out
        fi
    fi      
}

###############################################################################
# Shows available between DDSML and EUDEV
function seleudev() {
  eval "MSG27=\"\${MSG${tz}27}\""
  eval "MSG26=\"\${MSG${tz}26}\""
  eval "MSG40=\"\${MSG${tz}40}\""
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      d "${MSG27}" \
      e "${MSG26}" \
      f "${MSG40}" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      DMPM="DDSML"
      break
    elif [ "${resp}" = "e" ]; then
      DMPM="EUDEV"
      break
    elif [ "${resp}" = "f" ]; then
      DMPM="DDSML+EUDEV"
      break
    fi
  done

  curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/redpill-load/master/bundled-exts.json" --output /home/tc/redpill-load/bundled-exts.json
  sudo rm -rf /home/tc/redpill-load/custom/extensions/ddsml
  sudo rm -rf /home/tc/redpill-load/custom/extensions/eudev
  writeConfigKey "general" "devmod" "${DMPM}"

}


###############################################################################
# Shows available between FRIEND and JOT
function selectldrmode() {
  eval "MSG28=\"\${MSG${tz}28}\""
  eval "MSG29=\"\${MSG${tz}29}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      f "${MSG28}" \
      j "${MSG29}" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "f" ]; then
      LDRMODE="FRIEND"
      break
    elif [ "${resp}" = "j" ]; then
      LDRMODE="JOT"
      break
    fi
  done

  writeConfigKey "general" "loadermode" "${LDRMODE}"

}

###############################################################################
# Shows available models to user choose one
function modelMenu() {

  M_GRP1="DS3622xs+ DS1621xs+ RS4021xs+ DS3617xs RS3618xs"
  M_GRP2="DS3615xs"
  M_GRP3="DVA3221 DVA3219"
  M_GRP4="DS918+ DS1019+"
  M_GRP5="DS923+ DS723+"
  M_GRP6="DS1621+ DS2422+ FS2500"
  M_GRP7="DS920+ DS1520+ DVA1622"
  
RESTRICT=1
while true; do
  echo "" > "${TMP_PATH}/mdl"
  
  if [ "$HBADETECT" = "ON" ]; then
    if [ $threads -gt 16 ]; then
      echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
    elif [ $threads -gt 8 ]; then
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
      else  
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
      fi
    else
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
      else
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
      fi
    fi
  else
    if [ $threads -gt 16 ]; then
      echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
    elif [ $threads -gt 8 ]; then
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
      else
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
      fi
    else
      if [ "${AFTERHASWELL}" == "OFF" ]; then
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
      else
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP7}" >> "${TMP_PATH}/mdl"		
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
	RESTRICT=0
      fi
    fi
  fi	  
  
  if [ ${RESTRICT} -eq 1 ]; then
        echo "Release-model-restriction" >> "${TMP_PATH}/mdl"
  else  
        echo "" > "${TMP_PATH}/mdl"
        echo "${M_GRP1}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP2}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP4}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP5}" >> "${TMP_PATH}/mdl"
        echo "${M_GRP7}" >> "${TMP_PATH}/mdl"		
        echo "${M_GRP6}" >> "${TMP_PATH}/mdl"	
        echo "${M_GRP3}" >> "${TMP_PATH}/mdl"
  fi
  
  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
    --menu "Choose a model\n" 0 0 0 \
    --file "${TMP_PATH}/mdl" 2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return  
  
  if [ "${resp}" = "Release-model-restriction" ]; then
    RESTRICT=0
    continue
  fi
  break
done
    
  MODEL="`<${TMP_PATH}/resp`"
  writeConfigKey "general" "model" "${MODEL}"
  setSuggest
}

# Set Describe model-specific requirements or suggested hardware
function setSuggest() {

  line="-------------------------------------------------------\n"
  case $MODEL in
    DS3622xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    DS1621xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    RS4021xs+)   platform="broadwellnk";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    DS918+)      platform="apollolake";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}17}, \${MSG${tz}18}\"";;
    DS1019+)     platform="apollolake";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}17}, \${MSG${tz}18}\"";;
    DS923+)      platform="r1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}20}\"";;
    DS723+)      platform="r1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}20}\"";;
    DS920+)      platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), \${MSG${tz}17}\"";;
    DS1520+)     platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), \${MSG${tz}17}\"";;
    DVA1622)     platform="geminilake";eval "desc=\"[${MODEL}]:${platform}(DT), \${MSG${tz}17}, \${MSG${tz}21}\"";;
    DS1621+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}22}\"";;
    DS2422+)     platform="v1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}22}\"";;
    FS2500)      platform="v1000";eval "desc=\"[${MODEL}]:${platform}\${MSG${tz}19}, \${MSG${tz}22}\"";;
    DS3615xs)    platform="bromolow";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}22}\"";;
    DS3617xs)    platform="broadwell";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    RS3618xs)    platform="broadwell";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}16}\"";;
    DVA3221)     platform="denverton";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}23}, \${MSG${tz}24}, \${MSG${tz}21}\"";;
    DVA3219)     platform="denverton";eval "desc=\"[${MODEL}]:${platform}, \${MSG${tz}23}, \${MSG${tz}25}, \${MSG${tz}21}\"";;
  esac

  result="${line}${desc}" 

}

###############################################################################
# Shows menu to user type one or generate randomly
function serialMenu() {
  eval "MSG30=\"\${MSG${tz}30}\""
  eval "MSG31=\"\${MSG${tz}31}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      a "${MSG30}" \
      m "${MSG31}" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "m" ]; then
      while true; do
        dialog --backtitle "`backtitle`" \
          --inputbox "Please enter a serial number " 0 0 "" \
          2>${TMP_PATH}/resp
        [ $? -ne 0 ] && return
        SERIAL=`cat ${TMP_PATH}/resp`
        if [ -z "${SERIAL}" ]; then
          return
        else
          break
        fi
      done
      break
    elif [ "${resp}" = "a" ]; then
      SERIAL=`./sngen.sh "${MODEL}"`
      break
    fi
  done
  SN="${SERIAL}"
  writeConfigKey "extra_cmdline" "sn" "${SN}"
}

###############################################################################
# Shows menu to generate randomly or to get realmac
function macMenu() {
  eval "MSG32=\"\${MSG${tz}32}\""
  eval "MSG33=\"\${MSG${tz}33}\""
  eval "MSG34=\"\${MSG${tz}34}\""  
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      c "${MSG32}" \
      d "${MSG33}" \
      m "${MSG34}" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "d" ]; then
      MACADDR=`./macgen.sh "randommac" $1 ${MODEL}`
      break
    elif [ "${resp}" = "c" ]; then
      MACADDR=`./macgen.sh "realmac" $1 ${MODEL}`
      break
    elif [ "${resp}" = "m" ]; then
      while true; do
        dialog --backtitle "`backtitle`" \
          --inputbox "Please enter a mac address " 0 0 "" \
          2>${TMP_PATH}/resp
        [ $? -ne 0 ] && return
        MACADDR=`cat ${TMP_PATH}/resp`
        if [ -z "${MACADDR}" ]; then
          return
        else
          break
        fi
      done
      break
    fi
  done
  
  if [ "$1" = "eth0" ]; then
      MACADDR1="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac1" "${MACADDR1}"
  fi
  
  if [ "$1" = "eth1" ]; then
      MACADDR2="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac2" "${MACADDR2}"
      writeConfigKey "extra_cmdline" "netif_num" "2"
  fi
  
  if [ "$1" = "eth2" ]; then
      MACADDR3="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac3" "${MACADDR3}"
      writeConfigKey "extra_cmdline" "netif_num" "3"
  fi

  if [ "$1" = "eth3" ]; then
      MACADDR4="${MACADDR}"
      writeConfigKey "extra_cmdline" "mac4" "${MACADDR4}"
      writeConfigKey "extra_cmdline" "netif_num" "4"
  fi

}

###############################################################################
# Permits user edit the user config
function editUserConfig() {
  while true; do
    dialog --backtitle "`backtitle`" --title "Edit with caution" \
      --editbox "${USER_CONFIG_FILE}" 0 0 2>"${TMP_PATH}/userconfig"
    [ $? -ne 0 ] && return
    mv "${TMP_PATH}/userconfig" "${USER_CONFIG_FILE}"
    [ $? -eq 0 ] && break
    dialog --backtitle "`backtitle`" --title "Invalid JSON format" --msgbox "${ERRORS}" 0 0
  done

  MODEL="$(jq -r -e '.general.model' $USER_CONFIG_FILE)"
  SN="$(jq -r -e '.extra_cmdline.sn' $USER_CONFIG_FILE)"
  MACADDR1="$(jq -r -e '.extra_cmdline.mac1' $USER_CONFIG_FILE)"
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
  MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
  NETNUM"=$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)"
}

function checkUserConfig() {

  if [ ! -n "${SN}" ]; then
    eval "echo \${MSG${tz}36}"
    eval "echo \${MSG${tz}35}"
    read answer
    return 1     
  fi
  
  if [ ! -n "${MACADDR1}" ]; then
    eval "echo \${MSG${tz}37}"
    eval "echo \${MSG${tz}35}"
    read answer
    return 1     
  fi

  netif_num=$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)
  netif_num_cnt=$(cat $USER_CONFIG_FILE | grep \"mac | wc -l)
                    
  if [ $netif_num != $netif_num_cnt ]; then
    echo "netif_num = ${netif_num}"
    echo "number of mac addresses = ${netif_num_cnt}"       
    eval "echo \${MSG${tz}38}"
    eval "echo \${MSG${tz}35}"
    read answer
    return 1     
  fi  

}

###############################################################################
# Where the magic happens!
function make() {

  checkUserConfig 
  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error loader building" 0 0 #--textbox "${LOG_FILE}" 0 0      
    return 1  
  fi

  usbidentify
  clear

  if [ "$1" = "jun" ]; then
      ./my.sh "${MODEL}"J noconfig | tee "/home/tc/zlastbuild.log"    
  else
      ./my.sh "${MODEL}"F noconfig $1 | tee "/home/tc/zlastbuild.log"  
  fi

  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error loader building" 0 0 #--textbox "${LOG_FILE}" 0 0    
    return 1
  fi

  echo "Ready!"
  echo "press any key to continue..."
  read answer
  return 0
}

###############################################################################
# Post Update for jot mode 
function postupdate() {
  ./my.sh "${MODEL}" postupdate | tee "/home/tc/zpostupdate.log"
  echo "press any key to continue..."
  read answer
  return 0
}

###############################################################################
# Shows available language to user choose one
function langMenu() {

  dialog --backtitle "`backtitle`" --default-item "${LAYOUT}" --no-items \
    --menu "Choose a language" 0 0 0 "English" "한국어" "日本語" "中文" "Русский" \
    "Français" "Deutsch" "Español" "Italiano" "brasileiro" \
    2>${TMP_PATH}/resp
    
  [ $? -ne 0 ] && return
  resp=$(<${TMP_PATH}/resp)
  [ -z "${resp}" ] && return  
  
  case `<"${TMP_PATH}/resp"` in
    English) tz="US"; ucode="en_US";;
    한국어) tz="KR"; ucode="ko_KR";;
    日本語) tz="JP"; ucode="ja_JP";;
    中文) tz="CN"; ucode="zh_CN";;
    Русский) tz="RU"; ucode="ru_RU";;
    Français) tz="FR"; ucode="fr_FR";;
    Deutsch) tz="DE"; ucode="de_DE";;
    Español) tz="ES"; ucode="es_ES";;
    Italiano) tz="IT"; ucode="it_IT";;
    brasileiro) tz="BR"; ucode="pt_BR";;
  esac
  
  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
  sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8
  export LANG=${ucode}.utf8
  export LC_ALL=${ucode}.utf8
  
  writeConfigKey "general" "ucode" "${ucode}"  
  
  setSuggest
  
  return 0

}

###############################################################################
# Shows available keymaps to user choose one
function keymapMenu() {
  dialog --backtitle "`backtitle`" --default-item "${LAYOUT}" --no-items \
    --menu "Choose a layout" 0 0 0 "azerty" "colemak" \
    "dvorak" "fgGIod" "olpc" "qwerty" "qwertz" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  LAYOUT="`<${TMP_PATH}/resp`"
  OPTIONS=""
  while read KM; do
    OPTIONS+="${KM::-5} "
  done < <(cd /usr/share/kmap/${LAYOUT}; ls *.kmap)
  dialog --backtitle "`backtitle`" --no-items --default-item "${KEYMAP}" \
    --menu "Choice a keymap" 0 0 0 ${OPTIONS} \
    2>/tmp/resp
  [ $? -ne 0 ] && return
  resp=`cat /tmp/resp 2>/dev/null`
  [ -z "${resp}" ] && return
  KEYMAP=${resp}
  writeConfigKey "general" "layout" "${LAYOUT}"
  writeConfigKey "general" "keymap" "${KEYMAP}"
  loadkmap < /usr/share/kmap/${LAYOUT}/${KEYMAP}.kmap
  cd ~
}

function erasedisk() {
  ./edisk.sh
  echo "press any key to continue..."
  read answer
  return 0
}

function backup() {
  echo "y"|./rploader.sh backup
  echo "press any key to continue..."
  read answer
  return 0
}

function reboot() {
    clear
    sudo reboot
    break
}

# Main loop
tcrppart="$(mount | grep -i optional | grep cde | awk -F / '{print $3}' | uniq | cut -c 1-3)3"

#Get Langugae code & country code
if [ "${ucode}" == "null" ]; then
  tz=$(curl -s ipinfo.io | grep country | awk '{print $2}' | cut -c 2-3 )
    
  case "$tz" in
    US) ucode="en_US";;
    KR) ucode="ko_KR";;
    JP) ucode="ja_JP";;
    CN) ucode="zh_CN";;
    RU) ucode="ru_RU";;
    FR) ucode="fr_FR";;
    DE) ucode="de_DE";;
    ES) ucode="es_ES";;
    IT) ucode="it_IT";;
    BR) ucode="pt_BR";;
    *) tz="US"; ucode="en_US";;
  esac
    
else    
    ucode=$(jq -r -e '.general.ucode' "$USER_CONFIG_FILE")
    [ $? -ne 0 ] && ucode="en_US"
    tz=$(echo $ucode | cut -c 4-)    
fi

echo "tz = ${tz}"
echo "ucode = ${ucode}"

writeConfigKey "general" "ucode" "${ucode}"

#  export country=$tz
#  lang=$(curl -s https://restcountries.com/v2/all | jq -r 'map(select(.alpha2Code == env.country)) | .[0].languages | .[].iso639_1' | head -2)
#  if [ $? -eq 0 ]; then
#    ucode=${lang}_${tz}
#  else
#    tz="US"  
#    ucode="en_US"
#  fi

sed -i "s/screen_color = (CYAN,GREEN,ON)/screen_color = (CYAN,BLUE,ON)/g" ~/.dialogrc

echo "insert aterm menu.sh in /home/tc/.xsession"

sed -i "/locale/d" .xsession
sed -i "/utf8/d" .xsession
sed -i "/UTF-8/d" .xsession
sed -i "/aterm/d" .xsession
sed -i "/urxvt/d" .xsession

if [ "${ucode}" != "en_US" ]; then
  echo "[ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale &" >> .xsession
  echo "sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8" >> .xsession
  echo "export LANG=${ucode}.utf8" >> .xsession
  echo "export LC_ALL=${ucode}.utf8" >> .xsession
  echo "urxvt -geometry 78x32+525+0 -title \"M Shell for TCRP Menu\" -e /home/tc/menu.sh &" >> .xsession  
else
  echo "aterm -geometry 78x32+525+0 -title \"M Shell for TCRP Menu\" -e /home/tc/menu.sh &" >> .xsession
fi  
echo "aterm -geometry 78x32+10+0 -fg yellow -title \"TCRP Monitor\" -e /home/tc/rploader.sh monitor &" >> .xsession
echo "aterm -geometry 78x25+10+430 -fg orange -title \"TCRP NTP Sync\" -e /home/tc/ntp.sh &" >> .xsession
echo "aterm -geometry 78x25+525+430 -fg green -title \"TCRP Extra Terminal\" &" >> .xsession

if [ "${ucode}" != "en_US" ]; then

	if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep rxvt | wc -w) -eq 0 ]; then
	  tce-load -wi glibc_apps
	  tce-load -wi glibc_i18n_locale
	  tce-load -wi unifont
	  tce-load -wi rxvt
	  if [ $? -eq 0 ]; then
	    echo "Download glibc_apps.tcz and glibc_i18n_locale.tcz OK, Permanent installation progress !!!"
	    sudo cp -f /tmp/tce/optional/* /mnt/${tcrppart}/cde/optional
	    sudo echo "" >> /mnt/${tcrppart}/cde/onboot.lst	    
	    sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    sudo echo "glibc_i18n_locale.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    sudo echo "unifont.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    sudo echo "rxvt.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
	    echo 'Y'|./rploader.sh backup

	    echo
	    echo "You have finished installing TC Unicode package and urxvt. A reboot is required. Press any key to reboot..."
	    read answer

	    sudo reboot
	  else
	    echo "Download glibc_apps.tcz, glibc_i18n_locale.tcz FAIL !!!"
	  fi
	fi
	[ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
	sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8
	export LANG=${ucode}.utf8
	export LC_ALL=${ucode}.utf8
	
        if [ $(cat ~/.Xdefaults|grep "URxvt.background: black" | wc -w) -eq 0 ]; then
	  echo "URxvt.background: black"  >> ~/.Xdefaults
	fi
        if [ $(cat ~/.Xdefaults|grep "URxvt.foreground: white" | wc -w) -eq 0 ]; then	
   	  echo "URxvt.foreground: white"  >> ~/.Xdefaults
        fi
        if [ $(cat ~/.Xdefaults|grep "URxvt.transparent: true" | wc -w) -eq 0 ]; then	
   	  echo "URxvt.transparent: true"  >> ~/.Xdefaults
        fi
else
        if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep rxvt | wc -w) -gt 0 ]; then
	  [ ! -d /usr/lib/locale ] && sudo mkdir /usr/lib/locale
	  sudo localedef -c -i ${ucode} -f UTF-8 ${ucode}.UTF-8
	  export LANG=${ucode}.utf8
	  export LC_ALL=${ucode}.utf8
	  
          if [ $(cat ~/.Xdefaults|grep "URxvt.background: black" | wc -w) -eq 0 ]; then
  	    echo "URxvt.background: black"  >> ~/.Xdefaults
  	  fi
          if [ $(cat ~/.Xdefaults|grep "URxvt.foreground: white" | wc -w) -eq 0 ]; then	
   	    echo "URxvt.foreground: white"  >> ~/.Xdefaults
          fi
          if [ $(cat ~/.Xdefaults|grep "URxvt.transparent: true" | wc -w) -eq 0 ]; then	
   	    echo "URxvt.transparent: true"  >> ~/.Xdefaults
          fi
	fi
fi	
locale
if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep "kmaps.tczglibc_apps.tcz" | wc -w) -gt 0 ]; then
    sudo sed -i "/kmaps.tczglibc_apps.tcz/d" /mnt/${tcrppart}/cde/onboot.lst	
    sudo echo "glibc_apps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
    echo
    echo "We have finished bug fix for /mnt/${tcrppart}/cde/onboot.lst. A reboot is required. Press any key to reboot..."
    read answer

    sudo reboot
fi	

if [ "${KEYMAP}" = "null" ]; then
    LAYOUT="qwerty"
    KEYMAP="us"
    writeConfigKey "general" "layout" "${LAYOUT}"
    writeConfigKey "general" "keymap" "${KEYMAP}"
fi

if [ "${DMPM}" = "null" ]; then
    DMPM="DDSML"
    writeConfigKey "general" "devmod" "${DMPM}"          
fi

if [ "${LDRMODE}" = "null" ]; then
    LDRMODE="FRIEND"
    writeConfigKey "general" "loadermode" "${LDRMODE}"          
fi

# Get actual IP
IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}' | cut -c 6- )"

if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
  MACADDR2="$(jq -r -e '.extra_cmdline.mac2' $USER_CONFIG_FILE)"
  NETNUM="2"
fi  
if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
  MACADDR3="$(jq -r -e '.extra_cmdline.mac3' $USER_CONFIG_FILE)"
  NETNUM="3"
fi  
if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
  MACADDR4="$(jq -r -e '.extra_cmdline.mac4' $USER_CONFIG_FILE)"
  NETNUM="4"
fi  

CURNETNUM="$(jq -r -e '.extra_cmdline.netif_num' $USER_CONFIG_FILE)"
if [ $CURNETNUM != $NETNUM ]; then
  if [ $NETNUM == "3" ]; then 
    DeleteConfigKey "extra_cmdline" "mac4"
  fi  
  if [ $NETNUM == "2" ]; then 
    DeleteConfigKey "extra_cmdline" "mac4"  
    DeleteConfigKey "extra_cmdline" "mac3"
  fi  
  if [ $NETNUM == "1" ]; then
    DeleteConfigKey "extra_cmdline" "mac4"  
    DeleteConfigKey "extra_cmdline" "mac3"
    DeleteConfigKey "extra_cmdline" "mac2"    
  fi  
  writeConfigKey "extra_cmdline" "netif_num" "$NETNUM"
fi

checkmachine
checkcpu

if [ $tcrppart == "mmc3" ]; then
    tcrppart="mmcblk0p3"
fi    

# Download dialog
if [ "$(which dialog)_" == "_" ]; then
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz" --output /mnt/${tcrppart}/cde/optional/dialog.tcz
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.dep" --output /mnt/${tcrppart}/cde/optional/dialog.tcz.dep
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/dialog.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/dialog.tcz.md5.txt
    tce-load -i dialog
    if [ $? -eq 0 ]; then
        echo "Download dialog OK !!!"
    else
        tce-load -iw dialog
    fi
    sudo echo "dialog.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi

# Download kmaps
if [ $(cat /mnt/${tcrppart}/cde/onboot.lst|grep kmaps | wc -w) -eq 0 ]; then
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz" --output /mnt/${tcrppart}/cde/optional/kmaps.tcz
    sudo curl --insecure -L "https://raw.githubusercontent.com/PeterSuh-Q3/tinycore-redpill/master/tce/optional/kmaps.tcz.md5.txt" --output /mnt/${tcrppart}/cde/optional/kmaps.tcz.md5.txt
    tce-load -i kmaps
    if [ $? -eq 0 ]; then
        echo "Download kmaps OK !!!"
    else
        tce-load -iw kmaps
    fi
    sudo echo "kmaps.tcz" >> /mnt/${tcrppart}/cde/onboot.lst
fi
loadkmap < /usr/share/kmap/${LAYOUT}/${KEYMAP}.kmap

NEXT="m"
setSuggest

# Until urxtv is available, Korean menu is used only on remote terminals.
while true; do
  eval "echo \"c \\\"\${MSG${tz}01}\\\"\""               > "${TMP_PATH}/menu" 
  eval "echo \"m \\\"\${MSG${tz}02}\\\"\""               >> "${TMP_PATH}/menu"
  if [ -n "${MODEL}" ]; then
    eval "echo \"s \\\"\${MSG${tz}03}\\\"\""             >> "${TMP_PATH}/menu"
    eval "echo \"a \\\"\${MSG${tz}04} 1\\\"\""           >> "${TMP_PATH}/menu"
    if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
      eval "echo \"f \\\"\${MSG${tz}04} 2\\\"\""         >> "${TMP_PATH}/menu"
    fi  
    if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
      eval "echo \"g \\\"\${MSG${tz}04} 3\\\"\""         >> "${TMP_PATH}/menu"
    fi  
    if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
      eval "echo \"h \\\"\${MSG${tz}04} 4\\\"\""         >> "${TMP_PATH}/menu"
    fi
    if [ "${CPU}" == "HP" ]; then
      eval "echo \"j \\\"\${MSG${tz}05}\\\"\""           >> "${TMP_PATH}/menu"       
    else 
      eval "echo \"z \\\"\${MSG${tz}06} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"
      eval "echo \"d \\\"\${MSG${tz}07} (${LDRMODE})\\\"\""   >> "${TMP_PATH}/menu"
      if [ "${MODEL}" == "DS918+" ]||[ "${MODEL}" == "DS1019+" ]||[ "${MODEL}" == "DS920+" ]||[ "${MODEL}" == "DS1520+" ]; then        
        eval "echo \"o \\\"\${MSG${tz}08}\\\"\""         >> "${TMP_PATH}/menu"
      fi	
    fi
    if [ "${LDRMODE}" == "JOT" ]; then
      eval "echo \"p \\\"\${MSG${tz}09}\\\"\""           >> "${TMP_PATH}/menu"   
    fi
  fi
  eval "echo \"u \\\"\${MSG${tz}10}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"l \\\"\${MSG${tz}39}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"k \\\"\${MSG${tz}11}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"i \\\"\${MSG${tz}12}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"b \\\"\${MSG${tz}13}\\\"\""               >> "${TMP_PATH}/menu"  
  eval "echo \"r \\\"\${MSG${tz}14}\\\"\""               >> "${TMP_PATH}/menu"
  eval "echo \"e \\\"\${MSG${tz}15}\\\"\""               >> "${TMP_PATH}/menu"
  eval "MSG00=\"\${MSG${tz}00}\""
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "${MSG00}${result}" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    c) seleudev;        NEXT="m" ;;  
    m) modelMenu;       NEXT="s" ;;
    s) serialMenu;      NEXT="a" ;;
    a) macMenu "eth0"
        if [ $(ifconfig | grep eth1 | wc -l) -gt 0 ]; then
            NEXT="f" 
	else
            NEXT="z" 	
	fi
        ;;
    f) macMenu "eth1"
        if [ $(ifconfig | grep eth2 | wc -l) -gt 0 ]; then
            NEXT="g" 
	else
            NEXT="z" 	
	fi
        ;;
    g) macMenu "eth2"
        if [ $(ifconfig | grep eth3 | wc -l) -gt 0 ]; then
            NEXT="h" 
	else
            NEXT="z" 	
	fi
        ;;
    h) macMenu "eth3";    NEXT="z" ;;    
    z) selectldrmode ;    NEXT="d" ;;
    d) BUILD="42962"
       if [ "${LDRMODE}" == "FRIEND" ]; then
         make
       else
         make "jot"
       fi
       NEXT="r" ;;
    j) BUILD="42962"; make "jot";      NEXT="r" ;;    
    p) postupdate ;                    NEXT="r" ;;
    o) BUILD="42218"; make "jun";      NEXT="r" ;;
    u) editUserConfig;                 NEXT="d" ;;
    l) langMenu ;                      NEXT="m" ;;
    k) keymapMenu ;                    NEXT="m" ;;
    i) erasedisk ;                     NEXT="m" ;;
    b) backup ;                        NEXT="m" ;;
    r) reboot ;;
    e) break ;;
  esac
done

clear
echo -e "Call \033[1;32m./menu.sh\033[0m to return to menu"
