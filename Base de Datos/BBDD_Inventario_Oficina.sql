-- =========================================================================
-- SCRIPT DE BASE DE DATOS: inventario_oficina (PostgreSQL / Supabase)
-- =========================================================================

-- 1. Creación de la tabla con tipos de datos estructurados y restricciones
CREATE TABLE IF NOT EXISTS inventario_oficina (
    id VARCHAR(50) PRIMARY KEY,              -- Identificador único del producto (ej: 'IT-MON-24')
    nombre VARCHAR(100) NOT NULL,            -- Nombre descriptivo del artículo
    stock INTEGER NOT NULL DEFAULT 0,        -- Inventario físico actual disponible
    descripcion TEXT,                        -- Detalle, especificaciones técnicas o descripción comercial
    min INTEGER NOT NULL DEFAULT 0,          -- Stock mínimo de seguridad (Regla crítica)
    max INTEGER NOT NULL DEFAULT 0,          -- Capacidad máxima de almacenamiento
    categoria VARCHAR(100) NOT NULL,         -- Categoría lógica del producto (IT, Oficina, Equipamiento, etc.)
    en_transito BOOLEAN NOT NULL DEFAULT FALSE, -- Control de duplicidades en procesos de compra RPA
    
    -- Restricción básica para asegurar que el stock mínimo o máximo no tengan valores sin sentido
    CONSTRAINT chk_stock_non_negative CHECK (stock >= 0),
    CONSTRAINT chk_min_max CHECK (min <= max)
);

-- Comentarios de documentación para la interfaz de Supabase / Base de datos
COMMENT ON TABLE inventario_oficina IS 'Tabla de control de inventario reactivo para procesos de RPA e integraciones.';
COMMENT ON COLUMN inventario_oficina.en_transito IS 'Bandera de control para evitar que se envíe más de una orden de compra simultánea al orquestador por cada artículo.';

-- 2. Vaciamos las filas existentes antes de la inserción de prueba (para entornos de pruebas locales/Staging)
TRUNCATE TABLE inventario_oficina;

-- 3. Inserción del catálogo inicial con datos simulados y descripciones extendidas
INSERT INTO inventario_oficina (id, nombre, stock, descripcion, min, max, categoria, en_transito) VALUES
-- Categoría: Informática (IT)
('IT-MON-24', 'Monitor 24" FHD IPS', 14, 'Monitor de oficina de 24 pulgadas con resolución Full HD y panel IPS para ángulos de visión óptimos y reducción de fatiga ocular.', 4, 15, 'Informática (IT)', FALSE),
('IT-SSD-1T', 'Disco Duro Externo SSD 1TB', 8, 'Unidad de estado sólido externa de alta velocidad con conexión USB-C, ideal para copias de seguridad de datos masivos.', 3, 12, 'Informática (IT)', FALSE),
('IT-SWT-08', 'Switch Gigabit 8 Puertos TP-Link', 5, 'Conmutador de red de sobremesa con 8 puertos RJ45 a velocidad Gigabit para la expansión de la red cableada de la oficina.', 2, 6, 'Informática (IT)', FALSE),
('IT-RAT-IN', 'Ratón Inalámbrico Bluetooth', 22, 'Ratón óptico ergonómico con conectividad dual inalámbrica (Bluetooth y 2.4GHz) y batería de larga duración.', 5, 25, 'Informática (IT)', FALSE),
('IT-TEC-IN', 'Teclado Inalámbrico Español', 11, 'Teclado de perfil bajo, silencioso y resistente a salpicaduras, con distribución estándar en español.', 4, 15, 'Informática (IT)', FALSE),
('IT-CAB-HD', 'Cable HDMI 2.0 (2 metros)', 35, 'Cable de alta velocidad apantallado para la conexión de monitores, proyectores y portátiles, soporta resolución 4K.', 10, 45, 'Informática (IT)', FALSE),
('IT-PEN-64', 'Pendrive USB 3.0 64GB', 40, 'Memoria flash USB 3.0 compacta y resistant, ideal para transferencias rápidas de archivos y documentos cotidianos.', 12, 50, 'Informática (IT)', FALSE),
('IT-AUR-OF', 'Auriculares de Diadema USB', 15, 'Auriculares con micrófono integrado con cancelación de ruido, conexión USB plug-and-play, optimizados para videollamadas.', 5, 20, 'Informática (IT)', FALSE),
('IT-WEB-HD', 'Webcam 1080p Micrófono Integrado', 7, 'Cámara web de alta definición con enfoque automático y tapa de privacidad, ideal para reuniones virtuales y streaming.', 3, 10, 'Informática (IT)', FALSE),
('IT-TON-HP', 'Tóner Compatible HP 85A Negro', 6, 'Cartucho de tóner láser negro compatible de alto rendimiento, proporciona impresiones nítidas y consistentes.', 2, 10, 'Informática (IT)', FALSE),

-- Categoría: Oficina (OF)
('OF-PAP-A4', 'Folios A4 80g (Paquete 500)', 160, 'Paquete de papel de impresión multiusos tamaño A4 de alta blancura, perfecto para documentos e informes internos.', 40, 200, 'Oficina (OF)', FALSE),
('OF-BOL-AZU', 'Bolígrafo Azul Bic (Caja 50)', 90, 'Caja de bolígrafos de bola clásicos de tinta azul con punta de 1mm. Escritura fluida, suave y de larga duración.', 25, 120, 'Oficina (OF)', FALSE),
('OF-MAR-FL', 'Marcador Fluorescente Amarillo', 48, 'Rotulador marcador con punta de cincel para subrayar en dos grosores de línea, tinta brillante a base de agua.', 15, 60, 'Oficina (OF)', FALSE),
('OF-GRAP-M', 'Grapadora de Oficina Standard', 13, 'Grapadora metálica de sobremesa con base antideslizante, capacidad de grapado de hasta 25 hojas simultáneas.', 4, 15, 'Oficina (OF)', FALSE),
('OF-NOT-AD', 'Notas Adhesivas Post-it 75x75', 115, 'Bloque de notas cuadradas de colores con adhesivo reposicionable, no dejan residuos al despegarse.', 30, 150, 'Oficina (OF)', FALSE),

-- Categoría: Equipamiento y Varios (EP / VA)
('EP-GUA-LA', 'Guantes de Látex Desechables (100)', 18, 'Caja de 100 guantes de examen de látex natural, ambidiestros y con alta sensibilidad táctil para tareas de mantenimiento.', 6, 25, 'Equipamiento y Varios (EP / VA)', FALSE),
('EP-BOT-SE', 'Botas de Seguridad Talla 42', 4, 'Calzado de protección laboral con puntera de acero reforzada y suela antideslizante resistente a aceites.', 2, 6, 'Equipamiento y Varios (EP / VA)', FALSE),
('EP-MAS-FF', 'Mascarillas FFP2 (Caja 20)', 25, 'Caja de 20 mascarillas de protección respiratoria con alta capacidad de filtración de partículas y ajuste elástico cómodo.', 8, 30, 'Equipamiento y Varios (EP / VA)', FALSE),
('VA-CAF-CA', 'Cápsulas de Café (Caja 50)', 62, 'Caja de 50 cápsulas de café espresso surtido para máquinas de la oficina, tueste natural de intensidad media.', 20, 80, 'Equipamiento y Varios (EP / VA)', FALSE),
('VA-PAP-HI', 'Papel Higiénico Industrial', 12, 'Bobina de papel higiénico industrial de doble capa, alta absorción y resistencia para dispensadores de aseo comunes.', 4, 15, 'Equipamiento y Varios (EP / VA)', FALSE);