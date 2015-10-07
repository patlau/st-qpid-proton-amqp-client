<?xml version="1.0"?>

<st-source>
	<time-stamp>From LESS</time-stamp>
	<component-created>
		<name>Qpid-Proton</name>
		<type>package</type>
	</component-created>

<name-space>
 <name>Qpid</name>
 <environment>OS</environment>
 <private>false</private>
 <imports>
	Core.*
	External.*
	OS.*
</imports>
 <category></category>
 <attributes>
  <package>Qpid-Proton</package>
 </attributes>
</name-space>

<class>
 <name>QpidProtonDLL</name>
 <environment>OS.Qpid</environment>
 <super>External.ExternalInterface</super>
 <private>false</private>
 <indexed-type>none</indexed-type>
 <inst-vars></inst-vars>
 <class-inst-vars></class-inst-vars>
 <imports></imports>
 <category></category>
 <attributes>
  <includeFiles></includeFiles>
  <includeDirectories></includeDirectories>
  <libraryFiles>
   <item>qpid-proton.dll</item>
  </libraryFiles>
  <libraryDirectories></libraryDirectories>
  <beVirtual>false</beVirtual>
  <optimizationLevel>debug</optimizationLevel>
  <package>Qpid-Proton</package>
 </attributes>
</class>


	<methods>
		<class-id>OS.Qpid.QpidProtonDLL</class-id>
		<category>structs</category>
		<body package="Qpid-Proton" selector="__pn_messenger_t">__pn_messenger_t
	&lt;C: struct __pn_messenger_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_subscription_t">__pn_subscription_t
	&lt;C: struct __pn_subscription_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_message_t">__pn_message_t
	&lt;C: struct __pn_message_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_decimal128_t">__pn_decimal128_t
	&lt;C: struct __pn_decimal128_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_uuid_t">__pn_uuid_t
	&lt;C: struct __pn_uuid_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_bytes_t">__pn_bytes_t
	&lt;C: struct __pn_bytes_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_connection_t">__pn_connection_t
	&lt;C: struct __pn_connection_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_session_t">__pn_session_t
	&lt;C: struct __pn_session_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_link_t">__pn_link_t
	&lt;C: struct __pn_link_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_delivery_t">__pn_delivery_t
	&lt;C: struct __pn_delivery_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_collector_t">__pn_collector_t
	&lt;C: struct __pn_collector_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_transport_t">__pn_transport_t
	&lt;C: struct __pn_transport_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_atom_t">__pn_atom_t
	&lt;C: struct __pn_atom_t&gt;</body>
		<body package="Qpid-Proton" selector="__pn_data_t">__pn_data_t
	&lt;C: struct __pn_data_t&gt;</body>
	</methods>
</st-source>