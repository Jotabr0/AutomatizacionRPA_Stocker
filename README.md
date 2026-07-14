# Stocker RPA: Automatización Inteligente de Compras con Autostock

**Stocker RPA** es un ecosistema integral de automatización diseñado para transformar digitalmente el área de aprovisionamiento y gestión de inventarios de oficina. Este proyecto elimina los cuellos de botella del proceso manual (como la revisión física, búsqueda de precios y compras tediosas) garantizando el mejor precio, trazabilidad total y una precisión absoluta. 

## 🚀 Arquitectura y Tecnologías Utilizadas

El sistema está compuesto por cuatro componentes especializados que forman un ecosistema interconectado:

*   **La Memoria (Persistencia):** Base de datos PostgreSQL en **Supabase** para reflejar el estado del inventario en tiempo real, respaldada por **Microsoft Excel** como fuente inmutable para reportes y Power BI.
*   **Interfaz de Usuario (Punto de entrada):** Aplicación web **HTML5/JS** alojada en Netlify, que permite a los empleados registrar las retiradas de stock mediante una interfaz táctil en menos de 5 segundos.
*   **El Cerebro (Orquestación):** **n8n** (self-hosted) evalúa las reglas de negocio en tiempo real y **Power Automate Cloud** gestiona las colas de trabajo (Work Queues) enviando las peticiones a los robots.
*   **Las Manos (Ejecución):** **Power Automate Desktop (PAD)** actúa como el robot performer desatendido, encargado de realizar el *web scraping* y la ejecución de la compra en los e-commerce.
*   **La Voz (Gobernanza):** Un bot integrado en **Microsoft Teams** (o **Telegram**) que envía tarjetas interactivas para que los responsables de compras aprueben o rechacen los presupuestos con un solo clic.

## ⚙️ Flujo del Proceso (TO-BE)

El flujo de trabajo automatizado sigue estos pasos para garantizar eficiencia y seguridad:

1.  **Extracción de Material:** El empleado retira un artículo e indica la cantidad en la interfaz web de Stocker. Un Webhook en n8n recibe la información y actualiza el stock en la base de datos de Supabase.
2.  **Detección Preventiva:** n8n supervisa continuamente el inventario. Si el stock cae por debajo del umbral preventivo (**mínimo × 1,10**), calcula la cantidad a reponer y añade el artículo a la cola de trabajo (Dispatcher).
3.  **Rastreo y Scraping Avanzado:** Power Automate Desktop lanza instancias en modo incógnito y busca simultáneamente en proveedores como Amazon, MediaMarkt y PcComponentes. Extrae datos críticos y un algoritmo selecciona matemáticamente el **proveedor con el mejor precio** y disponibilidad de stock.
4.  **Aprobación Directiva:** PAD consolida un reporte en Excel y envía una notificación estructurada (con producto, tienda, cantidad y coste) vía Microsoft Teams al responsable de compras. El ciclo queda en suspensión programada a la espera de la validación humana.
5.  **Checkout Autónomo y Cierre:** Tras hacer clic en "Aprobar", PAD inyecta los datos de envío, utiliza credenciales de pago encriptadas (mediante Azure Key Vault) y ejecuta la compra en la web ganadora en menos de 3 minutos. Finalmente, extrae el recibo, actualiza el estado en Supabase y notifica al departamento la reposición del stock. Cuenta además con una lógica de *fallback* para saltar al siguiente proveedor si el principal falla.

## 📊 Impacto y Beneficios

La implementación de Stocker RPA logra una mejora macro en los procesos de la empresa:

*   ⏱️ **94% de Ahorro de Tiempo:** El proceso manual, que tomaba alrededor de 120 minutos, se colapsa a una ejecución desatendida de tan solo 5 minutos.
*   🎯 **0.00% Tasa de Error:** Eliminación total de errores de transcripción, copias equivocadas de precios o pedidos duplicados gracias a la inyección directa de datos.
*   📈 **+90% ROI Productivo:** Libera el capital humano de tareas administrativas sin valor añadido, permitiendo enfocar los recursos en estrategia, análisis y negociación.

## 👥 Autores

Este proyecto ha sido desarrollado con el patrocinio de **Generation España** por el siguiente equipo de Desarrolladores RPA y Analistas:

*   **Ana Núñez**
*   **Alejandro González**
*   **Jose Manuel González**
*   **Juan Fernández**
*   **Javier Jaenes**

***

