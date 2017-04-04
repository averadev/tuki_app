---------------------------------------------------------------------------------
-- Tuki
-- Alberto Vera Espitia
-- GeekBucket 2016
---------------------------------------------------------------------------------

-- Mediciones de pantalla
intW = display.contentWidth
intH = display.contentHeight
midW = display.contentCenterX
midH = display.contentCenterY
hm3 = intH / 3
h = display.topStatusBarContentHeight

-- Colors
cWhite = { 1 }
cGrayXXL = { .96 }
cGrayXL = { .9 }
cGrayL = { .7 }
cGrayM = { .63 }
cGrayH = { .45 }
cGrayXH = { .29 }
cGrayXXH = { .14 }
cBlue = { 0, .62, .89  }
cBlueH = { .19, 0, .29  }
cPurple = { .27, .11, .36  }
cPurpleL = { .38, .17, .51  }
cTurquesa = { .18, .74, .93  }
cTurquesaL = { .49, .81, .96  }
cTurquesaXL = { .96, .99, 1 }
cFB = { 0, .42, .68 }
cBTur = { 0, .67, .92 }
cBBlu = { .19, 0, .29 }
cBPur = { .26, .05, .38 }

-- Fonts
fontLight = 'Raleway Light'
fontRegular = 'Raleway'
fontSemiBold = 'Raleway SemiBold'
fontBold = 'Raleway ExtraBold'

-- Otras
myTuks = ''
gpsLat = 0
gpsLon = 0
myWallet = 0
myMessages = 0
locIdCity = 0
oneSignalId = 0
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'}

-- Terminos y Condiciones
tukiTerminos = {
    'Lee detenidamente estos Términos y Condiciones (Términos). Al registrarse en la plataforma y utilizar la tarjeta y/o aplicaciones de Tuki, los Afiliados aceptan los términos de uso establecidos en este documento. Si no aceptas el total de los términos, no podrás participar en el programa. Tuki se reserva el derecho de modificar o cambiar estos Términos en cualquier momento, y a su entera discreción. Las modificaciones o cambios entrarán en vigor al momento que sean publicadas en www.tukicard.com/terminos. Estos Términos aplican a tu acceso y participación en programas de lealtad que Comercios operan en la plataforma Tuki (Comercio(s)). Para el propósito de este documento, un Comercio es toda persona moral o física que ofrezca a sus clientes recompensas y ofertas por el registro de sus visitas o compras en la plataforma Tuki. Tuki es operado por “Mobile Ads and Rewards Corporation, SAPI de CV” (de ahora en adelante “Tuki”) con domicilio en Calle Chacá SM23 M47 L1, Cancún, Quintana Roo, CP 77500, México. Los programas de lealtad pertenecen y son operados por cada Comercio. Cada Comercio tiene sus propios términos y condiciones (Términos de Comercio), por lo que deberás conocerlos antes de registrar tu primera visita. Conócelos en la página web del Comercio, o en la página del Comercio en la aplicación digital Tuki. Al registrar tu primera visita en un Comercio, aceptas los Términos de Comercio aplicables.',
    'Tuki es una plataforma digital en la que múltiples Comercios operan sus programas de lealtad. Tuki permite a consumidores afiliados (Afiliados) acceder a los programas de todos los Comercios con una misma tarjeta y/o desde una misma aplicación digital. Las aplicaciones digitales (Aplicación) de Tuki se encuentran listadas en www.tukicard.com/apps. La lista de Comercios afiliados a Tuki se puede encontrar en www.tukicard.com/comercios.',
    'Solo mayores de 18 años deben afiliarse a Tuki. Si tienes entre 13 y 18 años, puedes afiliarte y participar bajo la supervisión de un adulto que acepte los Términos del programa.',
    'Puedes obtener una tarjeta Tuki en cualquier Comercio, y activarla registrándote en la tableta Tuki del Comercio. Para registrarte, deberás proveer por lo menos: correo electrónico, nombre y apellido, y preferentemente: fecha de nacimiento, género, teléfono y dirección. Para acceder a tu cuenta en Aplicaciones, deberás elegir una contraseña. A partir de tu registro, los Comercios te otorgarán puntos cada vez que visites sus establecimientos o compres sus productos o servicios, en base a los términos y condiciones que cada Comercio establezca. Los puntos se acumulan únicamente en la bolsa del Comercio que los otorga, y solo sirven para acceder a las recompensas que el Comercio que otorgó los puntos establezca. Es responsabilidad exclusiva de cada Comercio establecer y cumplir las reglas de otorgamiento, caducidad y redención de sus puntos. Cada Comercio establecerá una serie de recompensas a las que puedas acceder redimiendo tus puntos. Para el otorgamiento y redención de puntos, será necesario que presentes tu tarjeta Tuki original y/o el código QR que te identifica como Afiliado en alguna de las aplicaciones digitales Tuki. Tuki no se hace responsable del incumplimiento de los Comercios respecto a sus programas de lealtad, otorgamiento o redención de puntos, y entrega de recompensas.',
    'Tuki se reserva el derecho de realizar cualquier cambio a la funcionalidad de la plataforma y sus aplicaciones sin previo aviso, siempre que no modifique el saldo de puntos, y la posibilidad de redimirlos por recompensas previamente establecidas por Comercios. A su entera conveniencia, Tuki desarrollará actualizaciones de las Aplicaciones, y dará a Afiliados un plazo de 30 días naturales para reemplazar las Aplicaciones anteriores por las nuevas. Una vez vencido este plazo, Tuki no se hará responsable del funcionamiento de la aplicación anterior.',
    'Cada Afiliado es responsable del resguardo y uso de su tarjeta Tuki, y de su usuario y contraseña que dan acceso a su aplicación digital. El Afiliado reconoce y acepta que cualquier portador de la tarjeta o QR que lo identifique en la aplicación digital Tuki podrá acumular puntos, y acceder a recompensas, por lo que ni Tuki, ni los Comercios serán responsables del uso que un tercero haga de la tarjeta.',
    'Tuki y los Comercios no cobran a Afiliados ningún tipo de cuota por expedición, activación o uso de la tarjeta y/o aplicaciones. Si por error, activas más de una tarjeta o cuenta, puedes integrar los saldos a una misma cuenta escribiendo a cuentas@tukicard.com. Tuki se reserva el derecho de negar la integración de cuentas si no puede confirmar la identidad del Afiliado a su entera satisfacción. En caso de extraviar tu tarjeta, podrás reponerla escribiendo a cuentas@tukicard.com indicando tus datos de contacto para poderte contactar por teléfono. Deberás tener a la mano una tarjeta nueva, y conocer y tener acceso al correo electrónico con el que te registraste.',
    'El Afiliado reconoce que los programas de lealtad operados por Comercios afiliados a Tuki son de puntos, y en ningún caso se podrán redimir los saldos en puntos por dinero en efectivo. El Afiliado reconoce que los Comercios pueden otorgan puntos y ofrecer recompensas de forma distinta a cada afiliado, por lo que se compromete a no realizar reclamación alguna respecto a otorgamiento de puntos o recompensas que no tenga disponible en su cuenta.',
    'Cualquier disputa respecto al otorgamiento de puntos o recompensas deberá dirimirse entre el Afiliado y el Comercio. Si el Comercio sospecha de una falla de plataforma, lo notificará a Tuki para su revisión. En cualquier caso, será el Comercio quien notifique el resultado al Afiliado. Tuki no investiga posibles fallas de plataforma después de 30 días calendario.',
    'Tuki se reserva el derecho de dar de baja cuentas que lleven 18 (dieciocho) meses o más de inactividad, sin responsabilidad respecto a los saldos de puntos acumulados en la cuenta al momento de la cancelación. Se considera una cuenta inactiva cuando no acumula puntos o los redime por recompensas.',
    'Las tarjetas Tuki son intransferibles, por lo que solo el titular está autorizado a utilizar la tarjeta para acumular puntos y acceder a recompensas. Nos reservamos el derecho de retirar o cancelar una tarjeta o cuenta cuando quien la use no sea el titular registrado, cuando el Afiliado viole los Términos de Tuki o de uno de los Comercios, o el uso de la Tarjeta o cuenta es fraudulenta o ilegal.'
}

tukiPrivacidad = {
    'La empresa responsable de la protección de tus datos de registro, perfil y operación en Tuki será “Mobile Ads and Rewards Corporation, SAPI de CV” (de ahora en adelante “Tuki”) con domicilio en Calle Chacá SM23 M47 L1, Cancún, Quintana Roo, 77500, México, los términos utilizados dentro del presente Aviso de Privacidad serán los mismos definidos dentro de los términos y condiciones en www.tukicard.com/terminos.',
    'Los datos personales que obtenemos de nuestros clientes son: correo electrónico, cuenta de Facebook®, nombre y apellido, fecha de nacimiento, género, teléfono y dirección. Adicional a esto, acumulamos información de las transacciones que realizas en los comercios que utilizan Tuki para sus programas de lealtad, incluyendo, fecha, hora, sucursal, comercio, monto de puntos acumulados y redimidos, y recompensas recibidas. Para acceder a tu cuenta vía web o aplicaciones, deberás elegir una contraseña. Cuando utilizas nuestra aplicación, obtenerlos tu ubicación geográfica.',
    'Los datos personales los obtenemos con la finalidad de atender aclaraciones, quejas y sugerencias; evaluar la calidad de nuestro servicio; darte de alta en los programas de lealtad de Comercios en los que elijas participar; presentarte en nuestras aplicaciones los comercios y ofertas más cercanas a tu dirección registrada o ubicación geográfica; identificarte para la entrega de recompensas; identificar tu perfil para ofrecerte ofertas y recompensas relevantes; análisis y estadística de nuestros afiliados; tramitar y responder Solicitudes de Ejercicio de Derechos ARCO y de Revocación de Consentimiento.',
    'Los datos personales de Afiliados no serán compartidos con terceros, ni con todos los Comercios que utilizan Tuki para sus programas de lealtad. Cuando el Afiliado registra por primera vez su visita a un Comercio, da su consentimiento para quedar registrado en el programa de lealtad de ese Comercio, y con ello autoriza a Tuki a compartir con el Comercio únicamente su nombre, correo electrónico, así como transacciones de acumulación y redención de puntos en ese comercio. Los Comercios podrán enviar a través de Tuki correos a los Afiliados a su propio programa de lealtad. El Afiliado podrá en cualquier momento optar por dejar de recibir correos de Comercios específicos, modificando las preferencias de su cuenta solicitándolo con un correo dirigido a privacidad@tukicard.com o en la Aplicación, con lo que Tuki dejará de enviar correos de ese Comercio al Afiliado. Tuki no se hace responsable de correos enviados por Comercios fuera de su plataforma, y te invita a leer los términos y condiciones, así como el aviso de privacidad de cada comercio en el que registres tus compras. Si deseas que tus datos no sean compartidos con los Comercios que utilizan Tuki para sus programas de lealtad, defínelo en las preferencias de tu cuenta, o escríbenos a privacidad@tukicard.com. Esta solicitud no será motivo para dejar de brindarte el servicio de Tuki.',
    'Los Comercios en los que el Afiliado haya registrado visitas, podrán enviar notificaciones al Afiliado a través de las Aplicaciones de Tuki. El Afiliado podrá optar por no recibir notificaciones de ningún Comercio, o de comercios en particular, ajustando las preferencias de su cuenta desde su Aplicación.',
    'Tienes derecho a acceder, rectificar, cancelar y oponerse al derecho que otorgas a Tuki de utilizar tus datos personales. Si no te es posible acceder y/o rectificar tus datos personales de tu cuenta vía web o aplicaciones, requerimos que lo solicites por escrito a privacidad@tukicard.com, con el texto: “Deseo acceder, rectificar, oponerme y/o cancelar el derecho de uso de mi información en manos de Tuki”, indica tu nombre, número de cuenta y teléfono. Uno de nuestros ejecutivos se pondrá en contacto contigo para realizar el trámite. Para que puedas ejercer tus derechos deberás demostrar que tú eres el titular de los datos o, en caso de que lo hagas a través de tu representante, deberás acreditar ésta situación. Esto está pensado para que nadie más que tú o tu representante, puedan decidir el uso que se le dará a tus datos personales; es por tu protección y la de tu información. Para lo anterior podrás utilizar diversas identificaciones, por ejemplo: la credencial para votar, tu pasaporte, la cartilla militar o algunas más que puedan acreditar que tú eres la persona de la que se están tratando datos personales, y de ésta manera evitar el uso malintencionado que alguien pueda hacer de tus derechos y, por lo tanto, de tus datos personales. Tuki se reserva el derecho de cancelar una cuenta, cuando el titular haya cancelado los derechos otorgados a Tuki para el manejo de su información.',
    'Puedes solicitar que te confirmemos que dimos fin al uso de tu información personal, en caso de que haya procedido tu solicitud de revocación del consentimiento, enviando un correo a privacidad@tukicard.com.',
    'Este Aviso de Privacidad podrá ser modificado o actualizado en cualquier momento; en su caso, se hará de su conocimiento mediante él envió de un correo electrónico con el “Aviso de Privacidad Tuki” a la cuenta que tú nos proporcionaste inicialmente; en caso de que no contemos con tu correo, puedes consultar el Aviso de Privacidad en este mismo portal de internet.',
    'Si tienes cualquier duda respecto a nuestro Aviso de Privacidad, escríbenos a privacidad@tukicard.com, o búscanos en nuestra oficina en Calle Chacá SM23 M47 L1, Cancún, Quintana Roo, 77500, México.',
    'Facebook® es marca registrada de Facebook Inc.'
}

local Globals = {}
Globals.filtros = {
    {"TODO", "iconFilterA"}, 
    {"RESTAURANTES", "iconFilterB"}, 
    {"BARES Y DISCOS", "iconFilterC"}, 
    {"SERVICIOS", "iconFilterD"}, 
    {"HOTELES", "iconFilterE"}, 
    {"FITNESS", "iconFilterF"}, 
    {"PARQUES Y TOURS", "iconFilterG"}, 
    {"COMPRAS", "iconFilterH"},
    {"AUTOSERVICIOS", "iconFilterI"},
    {"OTROS", "iconFilterJ"}
}
Globals.scenes = { 'src.Home' }
Globals.menu = nil
return Globals