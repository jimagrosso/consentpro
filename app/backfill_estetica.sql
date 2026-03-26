-- ═══════════════════════════════════════════════════════
-- BACKFILL: 5 nuevas plantillas para Medicina Estética
-- Ejecutar en Supabase SQL Editor
-- ═══════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION admin_backfill_plantillas_estetica()
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  medico RECORD;
  plantilla RECORD;
  inserted_count INT := 0;
  skipped_count INT := 0;
  medicos_afectados INT := 0;
  already_exists BOOLEAN;
BEGIN

  -- Iterar sobre todos los médicos con Medicina Estética
  FOR medico IN
    SELECT id, nombre FROM perfiles
    WHERE especialidad IN ('Medicina Estética', 'micropigmentacion')
  LOOP
    medicos_afectados := medicos_afectados + 1;

    -- ── 1. Micropigmentación ──────────────────────────────
    SELECT EXISTS(
      SELECT 1 FROM plantillas
      WHERE medico_id = medico.id AND catalog_id = 'estetica_micropigmentacion'
    ) INTO already_exists;
    IF NOT already_exists THEN
      INSERT INTO plantillas (medico_id, catalog_id, titulo, tipo_procedimiento, nombre_procedimiento, descripcion, version)
      VALUES (
        medico.id,
        'estetica_micropigmentacion',
        'Micropigmentación (Dermopigmentación)',
        'Procedimiento estético',
        'Micropigmentación / Dermopigmentación cosmética',
        'CONSENTIMIENTO INFORMADO — MICROPIGMENTACIÓN

OBJETIVO: La micropigmentación consiste en la introducción de pigmentos biocompatibles en la dermis superficial mediante agujas especializadas. Se utiliza para definición de cejas (pelo a pelo, ombré, microblading), delineado de ojos, labios u otras zonas indicadas.

CÓMO SE REALIZA: Se aplica anestésico tópico. Se realiza el diseño previo para aprobación del paciente. Se introduce el pigmento en la dermis superficial. Duración: 1 a 3 horas.

BENEFICIOS ESPERADOS: Definición estética con duración de 1 a 3 años (variable según técnica, tipo de piel y cuidados). El resultado final se aprecia entre 4 y 6 semanas. Se requiere retoque a las 4-8 semanas.

RIESGOS COMUNES: Enrojecimiento e inflamación (días 1-3). Costras y descamación durante cicatrización (7-14 días, no retirar manualmente). Pérdida parcial del pigmento durante cicatrización. Color más oscuro los primeros días.

RIESGOS POCO FRECUENTES: Reacción alérgica al pigmento. Infección si no se siguen cuidados. Cicatrización anómala (queloides). Resultado asimétrico. Migración o cambio de tonalidad del pigmento con el tiempo.

CONTRAINDICACIONES: Embarazo o lactancia. Piel con heridas, infección o inflamación activa. Tendencia a queloides. Trastornos de la coagulación. Diabetes no controlada. Hipersensibilidad a pigmentos. Isotretinoína activa (requiere suspensión previa).

CUIDADOS POSTERIORES: Mantener zona limpia con producto cicatrizante indicado. No mojar 7 días (evitar piscinas, sudoración excesiva). No maquillaje durante cicatrización. No exposición solar mínimo 4 semanas. No rascar ni retirar costras. Usar protector solar una vez cicatrizada.

SEÑALES DE ALARMA: Enrojecimiento progresivo, secreción purulenta, fiebre, dolor intenso, reacción alérgica severa, formación de queloides. Consulte al profesional.

DECLARACIÓN: He leído y comprendido este documento. Tuve oportunidad de preguntar sobre la técnica, los pigmentos y los cuidados. Entiendo que el resultado depende en gran medida de los cuidados durante la cicatrización.

Disclaimer: Este documento es un modelo informativo. Debe ser revisado y adaptado por el profesional y su asesoría legal según normativa local.',
        1
      );
      inserted_count := inserted_count + 1;
    ELSE
      skipped_count := skipped_count + 1;
    END IF;

    -- ── 2. Peeling Químico ──────────────────────────────
    SELECT EXISTS(
      SELECT 1 FROM plantillas
      WHERE medico_id = medico.id AND catalog_id = 'estetica_peeling_quimico'
    ) INTO already_exists;
    IF NOT already_exists THEN
      INSERT INTO plantillas (medico_id, catalog_id, titulo, tipo_procedimiento, nombre_procedimiento, descripcion, version)
      VALUES (
        medico.id,
        'estetica_peeling_quimico',
        'Peeling Químico Facial',
        'Procedimiento estético',
        'Peeling químico facial (superficial, medio o profundo)',
        'CONSENTIMIENTO INFORMADO — PEELING QUÍMICO FACIAL

OBJETIVO: Aplicación controlada de una solución química sobre la piel para producir exfoliación que estimule la renovación cutánea. Clasificación: Superficial (ácido glicólico, mandélico, salicílico, TCA baja concentración), Medio (TCA 30-35%, Jessner+TCA), Profundo (fenol — requiere anestesia y monitoreo especial). El tipo indicado en su caso: [el médico especificará].

INDICACIONES: Manchas (melasma, hiperpigmentación), textura irregular, poros dilatados, acné leve-moderado, cicatrices superficiales, fotoenvejecimiento.

CÓMO SE REALIZA: Se limpia y prepara la piel. Se aplica la solución química con control preciso del tiempo de contacto. Se neutraliza o retira según protocolo. Duración: 30 a 60 minutos. Puede producir ardor, calor o picazón durante la aplicación.

PERÍODO DE DESCAMACIÓN ESPERADO: Días 1-3: enrojecimiento y calor. Días 3-7: inicio de descamación (NO retirar manualmente). Días 7-14: cicatrización progresiva.

RIESGOS COMUNES: Eritema y ardor durante y tras la aplicación. Descamación 3-10 días (parte del proceso). Sensibilidad cutánea temporal.

RIESGOS POCO FRECUENTES: Hiperpigmentación post-inflamatoria (mayor riesgo en fototipos oscuros). Hipopigmentación (más frecuente en peelings profundos). Infección bacteriana o viral (reactivación de herpes). Cicatrización anómala. Reacción alérgica.

CONTRAINDICACIONES: Embarazo o lactancia. Isotretinoína oral activa (suspensión mínima 6-12 meses previos). Herpes activo sin profilaxis. Piel con heridas o infecciones activas. Exposición solar reciente significativa. Queloides.

CUIDADOS POSTERIORES: NO rascar ni retirar costras. Aplicar hidratante y productos indicados por el médico. Protector solar SPF 50+ mínimo 3 meses. Evitar exposición solar durante cicatrización. No productos activos (retinoides, ácidos) hasta autorización médica.

SEÑALES DE ALARMA: Enrojecimiento progresivo, secreción purulenta, fiebre, dolor intenso. Contacte al médico.

DECLARACIÓN: He recibido información sobre el tipo de peeling, el agente a utilizar, cuidados previos y posteriores, y riesgos. Tuve la oportunidad de preguntar. Entiendo que la fotoprotección estricta es fundamental.

Disclaimer: Este documento es un modelo informativo. Debe ser revisado y adaptado por el profesional y su asesoría legal según normativa local.',
        1
      );
      inserted_count := inserted_count + 1;
    ELSE
      skipped_count := skipped_count + 1;
    END IF;

    -- ── 3. Láser Diodo ──────────────────────────────────
    SELECT EXISTS(
      SELECT 1 FROM plantillas
      WHERE medico_id = medico.id AND catalog_id = 'estetica_laser_diodo'
    ) INTO already_exists;
    IF NOT already_exists THEN
      INSERT INTO plantillas (medico_id, catalog_id, titulo, tipo_procedimiento, nombre_procedimiento, descripcion, version)
      VALUES (
        medico.id,
        'estetica_laser_diodo',
        'Depilación con Láser de Diodo',
        'Procedimiento estético',
        'Depilación definitiva con láser de diodo',
        'CONSENTIMIENTO INFORMADO — DEPILACIÓN CON LÁSER DE DIODO

OBJETIVO: El láser de diodo (habitualmente 808 nm) actúa sobre la melanina del folículo piloso generando calor que lo destruye selectivamente, logrando reducción permanente del vello. "Definitivo" significa reducción significativa y permanente, no necesariamente 100%.

CÓMO SE REALIZA: Se afeita la zona 24 horas antes. Se aplica gel conductor frío. El equipo emite pulsos de luz con sistema de enfriamiento integrado. Duración variable: minutos (labio superior) a 1-2 horas (piernas completas).

SESIONES NECESARIAS: 6 a 10 sesiones o más, con intervalos de 4 a 8 semanas (solo actúa en folículos en fase anágena activa). El número varía según tipo de vello, zona, fototipo y respuesta individual.

BENEFICIOS ESPERADOS: Reducción del 70-90% del vello tras el protocolo completo. El vello residual suele ser más fino y claro. No se garantiza eliminación total del 100%.

RIESGOS COMUNES: Eritema y calor en la zona (horas post-sesión). Foliculitis transitoria. Edema leve. Molestia durante la aplicación.

RIESGOS POCO FRECUENTES: Hiperpigmentación post-inflamatoria (mayor riesgo en piel bronceada). Hipopigmentación. Quemaduras superficiales (piel bronceada o parámetros incorrectos). Crecimiento paradójico del vello en algunos casos.

CONTRAINDICACIONES: Bronceado activo o reciente (mínimo 4-6 semanas sin sol antes de cada sesión). Embarazo. Autobronceantes. Herpes activo en la zona. Isotretinoína oral activa. Tatuajes en el área de tratamiento.

CUIDADOS PREVIOS A CADA SESIÓN: Afeitar 24h antes (NO cera, hilo ni pinzas). Sin sol ni autobronceantes 4-6 semanas previas. Sin perfumes ni desodorantes el día de la sesión.

CUIDADOS POSTERIORES: Frío local si hay molestia. Protector solar SPF 50+ en zona expuesta. Evitar sol directo 2-4 semanas post-sesión. Evitar sauna y ejercicio intenso 24-48h. No cera ni pinzas entre sesiones (solo afeitar).

SEÑALES DE ALARMA: Quemadura visible, ampollas, dolor intenso, signos de infección. Contacte al médico.

DECLARACIÓN: He recibido información sobre el número de sesiones necesarias, los cuidados indispensables (especialmente evitar el bronceado) y los riesgos. Entiendo que debo evitar el bronceado durante todo el protocolo.

Disclaimer: Este documento es un modelo informativo. Debe ser revisado y adaptado por el profesional y su asesoría legal según normativa local.',
        1
      );
      inserted_count := inserted_count + 1;
    ELSE
      skipped_count := skipped_count + 1;
    END IF;

    -- ── 4. Láser CO2 Fraccionado ─────────────────────────
    SELECT EXISTS(
      SELECT 1 FROM plantillas
      WHERE medico_id = medico.id AND catalog_id = 'estetica_laser_co2_fraccionado'
    ) INTO already_exists;
    IF NOT already_exists THEN
      INSERT INTO plantillas (medico_id, catalog_id, titulo, tipo_procedimiento, nombre_procedimiento, descripcion, version)
      VALUES (
        medico.id,
        'estetica_laser_co2_fraccionado',
        'Láser CO2 Fraccionado',
        'Procedimiento estético',
        'Resurfacing con láser CO2 fraccionado',
        'CONSENTIMIENTO INFORMADO — LÁSER CO2 FRACCIONADO

OBJETIVO: El láser CO2 fraccionado crea columnas microscópicas de microablación térmica (MTZ) en la piel rodeadas de tejido sano que acelera la recuperación. Se usa para cicatrices de acné, arrugas, textura irregular, manchas y fotoenvejecimiento.

CÓMO SE REALIZA: Se aplica anestésico tópico con oclusión 30-60 minutos antes. Se limpia la piel. El médico aplica el láser con los parámetros establecidos según objetivo y tipo de piel. Duración: 20 a 60 minutos. La piel quedará enrojecida e inflamada inmediatamente.

PERÍODO DE RECUPERACIÓN (fundamental comprenderlo antes):
• Días 1-3: Eritema intenso, edema, calor. Aspecto de "quemadura solar moderada"
• Días 3-7: Costras o micro-costras — NO retirar bajo ninguna circunstancia
• Días 7-14: Descamación progresiva, piel nueva rosada/rojiza
• Semanas 2-4: Normalización progresiva; eritema residual puede durar semanas adicionales
Se recomienda planificar con tiempo libre de actividades sociales/laborales mínimo 7-10 días.

BENEFICIOS ESPERADOS: Mejoría significativa en cicatrices de acné, arrugas, textura e irregularidades. Resultados se desarrollan 3-6 meses. No se garantizan resultados específicos.

RIESGOS COMUNES: Eritema, edema y calor significativos (días 1-5). Costras y descamación. Sensibilidad cutánea aumentada semanas. Eritema residual 4-12 semanas.

RIESGOS POCO FRECUENTES: Hiperpigmentación post-inflamatoria (mayor en fototipos oscuros). Infección bacteriana o reactivación de herpes. Cicatrización anómala. Hipopigmentación. Milia (quistes superficiales transitorios).

CONTRAINDICACIONES: Embarazo. Isotretinoína oral (suspensión mínima 6-12 meses previos). Herpes activo sin profilaxis. Infección activa en la zona. Piel bronceada. Queloides en área facial.

PROFILAXIS ANTIVIRAL: Si tiene historia de herpes labial, el médico indicará antiviral profiláctico 1-2 días antes y durante la cicatrización. Informe si tiene antecedentes.

CUIDADOS POSTERIORES: Aplicar hidratante/cicatrizante con frecuencia (no dejar secar). NO rascar ni retirar costras. Protector solar SPF 50+ mínimo 3-6 meses. Evitar sol directo mínimo 3 meses. No maquillaje hasta autorización médica.

SEÑALES DE ALARMA: Infección (fiebre, secreción purulenta, dolor creciente), ampollas grandes, manchas blancas persistentes, lesiones vesiculosas (posible herpes). Contacte al médico inmediatamente.

DECLARACIÓN: He recibido información detallada sobre el procedimiento, el período de recuperación (varias semanas), los cuidados obligatorios (fotoprotección y no retirar costras) y los riesgos. Entiendo que los resultados finales se aprecian meses después.

Disclaimer: Este documento es un modelo informativo. Debe ser revisado y adaptado por el profesional y su asesoría legal según normativa local.',
        1
      );
      inserted_count := inserted_count + 1;
    ELSE
      skipped_count := skipped_count + 1;
    END IF;

    -- ── 5. Inductores de Colágeno ─────────────────────────
    SELECT EXISTS(
      SELECT 1 FROM plantillas
      WHERE medico_id = medico.id AND catalog_id = 'estetica_inductores_colageno'
    ) INTO already_exists;
    IF NOT already_exists THEN
      INSERT INTO plantillas (medico_id, catalog_id, titulo, tipo_procedimiento, nombre_procedimiento, descripcion, version)
      VALUES (
        medico.id,
        'estetica_inductores_colageno',
        'Inductores de Colágeno (Bioestimuladores)',
        'Procedimiento estético',
        'Inductores de colágeno / Bioestimuladores dérmicos',
        'CONSENTIMIENTO INFORMADO — INDUCTORES DE COLÁGENO / BIOESTIMULADORES DÉRMICOS

OBJETIVO: Los bioestimuladores dérmicos estimulan los fibroblastos para producir colágeno de forma natural y progresiva. A diferencia de los rellenos (que ocupan espacio físicamente), generan resultados graduales a través de la respuesta biológica del organismo. Productos disponibles: ácido poliláctico (PLLA), hidroxiapatita de calcio (CaHA), ácido polinucleótido (PDRN/PN), entre otros.

DIFERENCIA CON RELLENOS (importante comprender): Los bioestimuladores NO están diseñados para corregir volumen inmediato. Los resultados definitivos se aprecian entre 3 y 6 meses. Esto debe comprenderse antes del tratamiento.

INDICACIONES: Pérdida de volumen y firmeza difusa, arrugas profundas, flacidez cutánea en cara, cuello, escote, manos. Mejoría de la calidad general de la piel.

CÓMO SE REALIZA: Se aplica anestésico tópico y/o bloqueo anestésico local. El médico inyecta el producto mediante agujas o cánulas en los planos indicados. Duración: 30 a 60 minutos. Puede observarse inflamación y nódulos transitorios — parte normal del proceso.

BENEFICIOS ESPERADOS: Mejoría progresiva de calidad, firmeza y volumen de la piel. Efectos pueden durar 1-2 años o más. Se recomienda protocolo inicial de 2-3 sesiones con intervalo de 4-6 semanas. No se garantizan resultados específicos.

RIESGOS COMUNES: Dolor, ardor y molestia durante y tras la inyección. Eritema, edema y hematomas (pueden ser más marcados que con rellenos). Nódulos palpables primeros días o semanas (habitualmente transitorios). Asimetría inicial.

RIESGOS POCO FRECUENTES: Nódulos persistentes que requieran manejo médico. Granulomas tardíos. Infección local. Hipersensibilidad. Oclusión vascular (riesgo existe; el médico está entrenado para prevención y manejo). Calcificaciones subcutáneas (especialmente con CaHA a largo plazo).

CONTRAINDICACIONES: Embarazo o lactancia. Enfermedades autoinmunes activas. Infección activa en la zona. Tendencia severa a queloides. Trastornos de coagulación activos. Expectativas no realistas. Antecedentes de granulomas a rellenos previos.

MASAJES POSTERIORES (si aplica — PLLA): El médico puede indicar masajes 5 minutos, 5 veces al día, durante 5 días (regla de los 5). Su cumplimiento es responsabilidad del paciente y fundamental para prevenir nódulos.

CUIDADOS POSTERIORES: Evitar presión sobre la zona 24 horas. Realizar masajes si se indican. Frío local si hay molestia. Evitar ejercicio intenso, sauna y calor el día del procedimiento.

SEÑALES DE ALARMA: Palidez, manchas cutáneas, dolor intenso o pérdida de sensibilidad (posible compromiso vascular — acudir inmediatamente). Signos de infección. Nódulos que aumenten progresivamente de tamaño.

DECLARACIÓN: He recibido información sobre el producto, el carácter progresivo de los resultados (semanas a meses), los cuidados post-procedimiento incluyendo masajes si aplica, y los riesgos. Entiendo que este tratamiento produce mejoría gradual y que los resultados no son inmediatos.

Disclaimer: Este documento es un modelo informativo. Debe ser revisado y adaptado por el profesional y su asesoría legal según normativa local.',
        1
      );
      inserted_count := inserted_count + 1;
    ELSE
      skipped_count := skipped_count + 1;
    END IF;

  END LOOP;

  RETURN jsonb_build_object(
    'medicos_afectados', medicos_afectados,
    'plantillas_insertadas', inserted_count,
    'plantillas_ya_existian', skipped_count,
    'status', 'ok'
  );
END;
$$;

-- Ejecutar el backfill inmediatamente
SELECT admin_backfill_plantillas_estetica();

-- Limpiar la función después de usarla (opcional)
-- DROP FUNCTION admin_backfill_plantillas_estetica();
