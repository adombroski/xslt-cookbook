<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xslt [
  <!--=======================================================-->
  <!-- XMI's high level organization constructs                                              -->
  <!--=======================================================-->
  <!ENTITY BE "Behavioral_Elements">
  <!ENTITY SM "&BE;.State_Machines">
  <!ENTITY SMC "&SM;.StateMachine.context">
  <!ENTITY SMT "&SM;.StateMachine.top">
  <!ENTITY MM "Model_Management.Model">
  <!ENTITY FC "Foundation.Core">
  <!ENTITY FX "Foundation.Extension_Mechanisms">

  <!--=======================================================-->
  <!-- Abbreviations for the basic elements of a XMI  file that are of most   -->
  <!-- interest to this stylesheet.                                                                    -->
  <!--=======================================================-->
  <!--The model as a whole -->
  <!ENTITY MODEL "XMI/XMI.content/&MM;">
  <!--Some generic kind of UML element -->
  <!ENTITY ELEM "&FC;.Namespace.ownedElement">
  <!ENTITY STATEMACH "&MODEL;/&ELEM;/&SM;.StateMachine">
  <!ENTITY STATE "&SM;.CompositeState">
  <!ENTITY SUBSTATE "&STATE;.substate">
  <!ENTITY PSEUDOSTATE "&SM;.PseudoState">
  <!ENTITY PSEUDOSTATE2 "&SMT;/&STATE;/&SUBSTATE;/&PSEUDOSTATE;">
  <!ENTITY ACTION "&BE;.Common_Behavior.ActionSequence/&BE;.Common_Behavior.ActionSequence.action">
  <!ENTITY GUARD "&SM;.Transition.guard/&SM;.Guard/&SM;.Guard.expression">
  <!--The association as a whole -->
  <!ENTITY ASSOC "&FC;.Association">
  <!--The connection part of the association-->
  <!ENTITY CONN "&ASSOC;.connection">
  <!--The ends of an association. -->
  <!ENTITY END "&ASSOC;End">
  <!ENTITY CONNEND "&CONN;/&END;">
  <!ENTITY ENDType "&END;.type">
  <!-- A UML class -->
  <!ENTITY CLASS "&FC;.Class">
  <!--The name of some UML entity -->
  <!ENTITY NAME "&FC;.ModelElement.name">
  <!--A operation -->
  <!ENTITY OP "&FC;.Operation">
  <!-- A parameter -->
  <!ENTITY PARAM "&FC;.Parameter">
  <!ENTITY PARAM2 "&FC;.BehavioralFeature.parameter/&PARAM;">
  <!-- The data type of a parameter -->
  <!ENTITY PARAMTYPE "&PARAM;.type/&FC;.DataType">
  <!--A UML sterotype -->
  <!ENTITY STEREOTYPE "&FC;.ModelElement.stereotype/&FX;.Stereotype">
  <!-- A Supertype relation (inheritance) -->
  <!ENTITY SUPERTYPE "&FC;.Generalization.supertype">
  <!ENTITY GENERALIZATION "&FC;.GeneralizableElement.generalization/&FC;.Generalization">
  <!--=======================================================-->
  <!--Formatting                                                                                             -->
  <!--=======================================================-->
  
  <!--Used to control code intenting -->
  <!ENTITY INDENT "    ">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text"/>
  
  <!--Index classes by their id -->
  <xsl:key name="classKey" match="&CLASS;" use="@xmi.id"/>
  <xsl:key name="classKey" match="&CLASS;" use="&NAME;"/>
  
  <!-- Index Stereoptypes by both name and xmi.id -->
  <xsl:key name="stereotypeKey" match="&FX;.Stereotype" use="@xmi.id"/>
  <xsl:key name="stereotypeKey" match="&FX;.Stereotype" use="&NAME;"/>
  
  <!--Index data types by their id -->
  <xsl:key name="dataTypeKey" match="&FC;.DataType" use="@xmi.id"/>
  
  <!--Index associations by their end classes -->
  <xsl:key name="associationKey" match="&ASSOC;" use="&CONNEND;/&ENDType;/&FC;.Interface/@xmi.idref"/>
  <xsl:key name="associationKey" match="&ASSOC;" use="&CONNEND;/&ENDType;/&CLASS;/@xmi.idref"/>
  
  <!--Index generalizations by their id -->
  <xsl:key name="generalizationKey" match="&FC;.Generalization" use="@xmi.id"/>

  <!--Index states and pseudo states together by their id -->
  <xsl:key name="stateKey" match="&SM;.SimpleState" use="@xmi.id"/>
  <xsl:key name="stateKey" match="&PSEUDOSTATE;" use="@xmi.id"/>
  
  <!--Index state transitions by their id -->
  <xsl:key name="transKey" match="&SM;.Transition" use="@xmi.id"/>
  
  <!--Index transitions events by their id -->
  <xsl:key name="eventsKey" match="&SM;.SignalEvent" use="@xmi.id"/>
  
  <!-- The xmi ids of stereoptypes used to encode State Pattern  in UML -->
  <xsl:variable name="STATE_MACH" select="key('stereotypeKey','StateMachine')/@xmi.id"/>
  <xsl:variable name="STATE" select="key('stereotypeKey','state')/@xmi.id"/>
  <xsl:variable name="DELEGATE" select="key('stereotypeKey','delegate')/@xmi.id"/>
  <xsl:variable name="ACTION" select="key('stereotypeKey','action')/@xmi.id"/>
  <xsl:variable name="DEFAULT" select="key('stereotypeKey','default')/@xmi.id"/>
  <xsl:variable name="PURE" select="key('stereotypeKey','pure')/@xmi.id"/>
  
  <xsl:template match="/">

    <!-- Declare state interface -->  
    <xsl:apply-templates mode="stateInterfaceDecl"
          select="&MODEL;/&ELEM;/&CLASS;[&STEREOTYPE;/@xmi.idref = $STATE_MACH]"/>

    <!-- Declare concrete states -->  
    <xsl:apply-templates mode="concreteStatesDecl"
         select="&MODEL;/&ELEM;/&CLASS;[not(&STEREOTYPE;)]"/>

    <!-- Declare state context class -->  
    <xsl:apply-templates mode="stateDecl" 
          select="&MODEL;/&ELEM;/&CLASS;[&STEREOTYPE;/@xmi.idref = $STATE_MACH]"/>
         
    <!--Implement states -->  
    <xsl:apply-templates mode="concreteStatesImpl" 
        select="&MODEL;/&ELEM;"/>

    <!--Implement context -->  
    <xsl:apply-templates mode="stateContextImpl"
         select="&MODEL;/&ELEM;/&CLASS;[&STEREOTYPE;/@xmi.idref = $STATE_MACH]"/>
        
  </xsl:template>
  
  <!-- STATE CONTEXT DECLARATION -->
  <xsl:template match="&CLASS;" mode="stateDecl">
  
    <!-- Find the class associated with this state context that is a state implementation   -->
    <!-- This is the type of the state machines corrent state memeber variable -->
    <xsl:variable name="stateImplClass">
      <xsl:variable name="stateClassId" select="@xmi.id"/>
      <xsl:for-each select="key('associationKey',$stateClassId)">
        <xsl:variable name="assocClassId" 
                                select="&CONNEND;[&ENDType;/*/@xmi.idref !=
                                                                        $stateClassId]/&ENDType;/*/@xmi.idref"/>
        <xsl:if test="key('classKey',$assocClassId)/&STEREOTYPE;/@xmi.idref = $STATE">
          <xsl:value-of select="key('classKey',$assocClassId)/&NAME;"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="className" select="&NAME;"/>
    
    <xsl:text>&#xa;class </xsl:text>
    <xsl:value-of select="$className"/>
    <xsl:text>&#xa;{&#xa;public:&#xa;&#xa;</xsl:text>

    
    <!--Ctor decl -->
    <xsl:text>&INDENT;</xsl:text>
    <xsl:value-of select="$className"/>::<xsl:value-of select="$className"/>
    <xsl:text>();&#xa;&#xa;</xsl:text>
   
    <!-- Delegates are operations that defer to the current state -->
    <xsl:apply-templates select="*/&OP;[&STEREOTYPE;/@xmi.idref = $DELEGATE]" 
                                           mode="declare"/>

    <!-- void changeState(AbstractState& newState) -->
    <xsl:text>&INDENT;void changeState(</xsl:text>
    <xsl:value-of select="$stateImplClass"/>
    <xsl:text>&amp; newSate) ;&#xa;</xsl:text>
    
    <xsl:text>&#xa;&#xa;</xsl:text>
    <!-- Non-Delegates are other operations operations that states invoke on the context -->
    <xsl:apply-templates select="*/&OP;[&STEREOTYPE;/@xmi.idref != $DELEGATE]"
                                           mode="declare"/>
    <xsl:text>&#xa;private:&#xa;&#xa;</xsl:text>
    <xsl:text>&INDENT;</xsl:text>
    <xsl:value-of select="$stateImplClass"/>
    <xsl:text>* m_State ;</xsl:text>
    <xsl:text>&#xa;&#xa;} ;&#xa;&#xa;</xsl:text>
    
  </xsl:template>
  
  <!-- CONCRETE STATES DECLARATION -->
  
  <xsl:template match="&CLASS;" mode="concreteStatesDecl">
    <xsl:text>class </xsl:text>
  <xsl:value-of select="&NAME;"/>
    <xsl:call-template name="baseClass"/>
    <xsl:text>&#xa;{&#xa;public:&#xa;&#xa;</xsl:text>
<!-- Concrete States are Singletons so we generate an instace method -->
    <xsl:text>&INDENT;static </xsl:text>
    <xsl:value-of select="&NAME;"/>
    <xsl:text>&amp; instance() ;</xsl:text>
    <xsl:text>&#xa;&#xa;private:&#xa;&#xa;</xsl:text>
<!-- We protect constructors of Singletons-->
    <xsl:text>&INDENT;</xsl:text>
    <xsl:value-of select="&NAME;"/>
    <xsl:text>() {} &#xa;</xsl:text>
    <xsl:text>&INDENT;</xsl:text>
    <xsl:value-of select="&NAME;"/>(const <xsl:value-of select="&NAME;"/>
    <xsl:text>&amp;) {} &#xa;</xsl:text>
    <xsl:text>&INDENT;void operator =(const </xsl:text>
    <xsl:value-of select="&NAME;"/>
    <xsl:text>&amp;) {} &#xa;</xsl:text>
    <xsl:apply-templates select="*/&OP;" mode="declare"/>
    <xsl:text>
} ;

</xsl:text>
  </xsl:template>
  
  <!-- Templates used to declare classes with all public members -->
  
  <xsl:template match="&CLASS;" mode="declare">
    <xsl:text>class&#x20;</xsl:text>
    <xsl:value-of select="&NAME;"/>
    <xsl:text>&#xa;{&#xa;public:&#xa;&#xa;</xsl:text>
    <xsl:apply-templates select="*/&OP;" mode="declare"/>
    <xsl:text>&#xa;} ;&#xa;</xsl:text>
  </xsl:template>
  
  <xsl:template match="&OP;" mode="declare">
    <xsl:variable name="returnTypeId"
                            select="&PARAM2;[&PARAM;.kind/@xmi.value = 
                                                                 'return']/&PARAMTYPE;/@xmi.idref"/>
      <xsl:text>&INDENT;</xsl:text>
    <xsl:if test="&STEREOTYPE;/@xmi.idref = $PURE">
      <xsl:text>virtual </xsl:text>
    </xsl:if>
    <xsl:value-of select="key('dataTypeKey',$returnTypeId)/&NAME;"/>
      <xsl:text>&#x20;</xsl:text>
    <xsl:value-of select="&NAME;"/>
    <xsl:text>(</xsl:text>
    <xsl:call-template name="parameters"/>
    <xsl:text>)</xsl:text>
    <xsl:if test="&STEREOTYPE;/@xmi.idref = $PURE">
      <xsl:text> = 0 </xsl:text>
    </xsl:if>
    <xsl:text>;&#xa;</xsl:text>
  </xsl:template>

  <!--Eat extra text nodes  --> 
  <xsl:template match="text()" mode="declare"/>
  
  <!-- STATE INTERFACE DECLARATION -->
  <xsl:template match="&CLASS;" mode="stateInterfaceDecl">

    <xsl:text>//Forward declarations&#xa;</xsl:text>
    <xsl:text>class </xsl:text>
    <xsl:value-of select="&NAME;"/>
    <xsl:text>;&#xa;&#xa;</xsl:text>
    
    <xsl:variable name="stateClassId" select="@xmi.id"/>
    <!-- Find the class associeted with the state context that is a stateImpl -->
    <xsl:for-each select="key('associationKey',$stateClassId)">
      <xsl:variable name="assocClassId"
                             select="&CONNEND;[&ENDType;/*/@xmi.idref != 
                                                                     $stateClassId]/&ENDType;/*/@xmi.idref"/>
      <xsl:if test="key('classKey',$assocClassId)/&STEREOTYPE;/@xmi.idref = $STATE">
        <xsl:apply-templates select="key('classKey',$assocClassId)" mode="declare"/>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>&#xa;&#xa;</xsl:text>
  </xsl:template>
  
  <!--Eat extra text nodes  --> 
  <xsl:template match="text()" mode="stateInterfaceDecl"/>
  
  <!-- STATE CONTEXT IMPLEMENTATION -->
  <xsl:template match="&CLASS;" mode="stateContextImpl">
  
    <xsl:variable name="stateImplClass">
      <xsl:variable name="stateClassId" select="@xmi.id"/>
      <xsl:for-each select="key('associationKey',$stateClassId)">
        <xsl:variable name="assocClassId"
                                select="&CONNEND;[&ENDType;/*/@xmi.idref !=
                                                                        $stateClassId]/&ENDType;/*/@xmi.idref"/>
        <xsl:if test="key('classKey',$assocClassId)/&STEREOTYPE;/@xmi.idref = $STATE">
          <xsl:value-of select="key('classKey',$assocClassId)/&NAME;"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="className" select="&NAME;"/>
    <xsl:text>//Constructor&#xa;</xsl:text>
    <xsl:value-of select="$className"/>::<xsl:value-of select="$className"/>
    <xsl:text>()&#xa;</xsl:text>
    <xsl:text>{&#xa;</xsl:text>
    <xsl:text>&INDENT;//Initialize state machine in start state &#xa;</xsl:text>
    <xsl:variable name="startStateName">
      <xsl:call-template name="getStartState">
        <xsl:with-param name="classId" select="@xmi.id"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:text>&INDENT;m_State = &amp;</xsl:text>
    <xsl:value-of select="$startStateName"/>
    <xsl:text>::instance() ;&#xa;</xsl:text>
    <xsl:text>}&#xa;&#xa;</xsl:text>

    <!-- void changeState(AbstractState& newState) -->
    <xsl:text>void </xsl:text>
    <xsl:value-of select="$className"/>
    <xsl:text>::changeState(</xsl:text>
    <xsl:value-of select="$stateImplClass"/>
    <xsl:text>&amp; newState)&#xa;</xsl:text>
    <xsl:text>{&#xa;</xsl:text>
    <xsl:text>&INDENT;m_State = &amp;newState;</xsl:text>
    <xsl:text>&#xa;}&#xa;&#xa;</xsl:text>
    
    <xsl:for-each select="*/&OP;[&STEREOTYPE;/@xmi.idref = $DELEGATE]">
      <xsl:variable name="returnTypeId" 
                             select="&PARAM2;[&PARAM;.kind/@xmi.value =
                                                                 'return']/&PARAMTYPE;/@xmi.idref"/>
      <xsl:value-of select="key('dataTypeKey',$returnTypeId)/&NAME;"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="$className"/>::<xsl:value-of select="&NAME;"/>
      <xsl:text>(</xsl:text>
      <xsl:call-template name="parameters"/>
      <xsl:text>)&#xa;</xsl:text>
      <xsl:text>{&#xa;</xsl:text>
      <xsl:text>&INDENT;m_State-></xsl:text>
      <xsl:value-of select="&NAME;"/>
      <xsl:text>(*this, </xsl:text>
      <xsl:for-each select="&PARAM2;[&PARAM;.kind/@xmi.value != 'return']">
        <xsl:value-of select="&NAME;"/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>);&#xa;</xsl:text>
      <xsl:text>}&#xa;&#xa;</xsl:text>
    </xsl:for-each>
    
    <xsl:for-each select="*/&OP;[&STEREOTYPE;/@xmi.idref != $DELEGATE]">
      <xsl:variable name="returnTypeId"
                              select="&PARAM2;[&PARAM;.kind/@xmi.value = 
                                                                  'return']/&PARAMTYPE;/@xmi.idref"/>
      <xsl:value-of select="key('dataTypeKey',$returnTypeId)/&NAME;"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="$className"/>::<xsl:value-of select="&NAME;"/>
      <xsl:text>(</xsl:text>
      <xsl:call-template name="parameters"/>
      <xsl:text>)&#xa;</xsl:text>
      <xsl:text>{&#xa;</xsl:text>
      <xsl:text>&INDENT;//!TODO: Implement behavior of this action&#xa;</xsl:text>
      <xsl:text>}&#xa;&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="text()" mode="stateContextImpl"/>

  <!-- CONCRETE STATES IMPLEMENTATION -->
  <xsl:template match="&CLASS;" mode="concreteStatesImpl">
    <xsl:variable name="classId" select="@xmi.id"/>
    <xsl:variable name="stateMachine"
                           select="/&STATEMACH;[&SMC;/&CLASS;/@xmi.idref = $classId]"/>
    <!-- For each state in the machine, generate its implementation -->
    <xsl:for-each select="$stateMachine//&PSEUDOSTATE; |
                                        $stateMachine//&SM;.SimpleState">
      <xsl:call-template name="generateState">
        <xsl:with-param name="stateClass" select="key('classKey',&NAME;)"/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <!--Eat extra text nodes  --> 
  <xsl:template match="text()" mode="concreteStatesImpl"/>
  
  <xsl:template name="generateState">
    <!--This is a xmi class corresponding the the state -->
    <xsl:param name="stateClass"/>
    <!-- The current context is some state -->
    <xsl:variable name="state" select="."/>
    <xsl:variable name="className" select="&NAME;"/>
    <xsl:if test="$className != $stateClass/&NAME;">
      <xsl:message terminate="yes">State and class do not match!</xsl:message>
    </xsl:if>
    <xsl:for-each select="$stateClass/*/&OP;">
      <xsl:variable name="returnTypeId" 
                             select="&PARAM2;[&PARAM;.kind/@xmi.value =
                                                                 'return']/&PARAMTYPE;/@xmi.idref"/>
      <xsl:value-of select="key('dataTypeKey',$returnTypeId)/&NAME;"/>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="$className"/>::<xsl:value-of select="&NAME;"/>
      <xsl:text>(</xsl:text>
      <xsl:call-template name="parameters"/>
      <xsl:text>)&#xa;</xsl:text>
      <xsl:text>{&#xa;</xsl:text>
      <xsl:for-each select="$state/&SM;.StateVertex.outgoing/&SM;.Transition">
        <xsl:call-template name="generateStateBody">
          <xsl:with-param name="transition" select="key('transKey',@xmi.idref)"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:text>&INDENT;&INDENT;context.errorMsg() ;&#xa;</xsl:text>
      <xsl:text>}&#xa;&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>
  
  
  <xsl:template name="generateStateBody">
    <xsl:param name="transition"/>
    <xsl:text>&INDENT;if (cmd == </xsl:text>
    <xsl:variable name="eventId"
                           select="$transition/&SM;.Transition.trigger/&SM;.SignalEvent/@xmi.idref"/>
    <xsl:value-of select="key('eventsKey',$eventId)/&NAME;"/>
    <xsl:if test="$transition/&SM;.Transition.guard">
      <xsl:text> &amp;&amp; </xsl:text>
      <xsl:value-of select="$transition/&GUARD;/*/Foundation.Data_Types.Expression.body"/>
      <xsl:text>()</xsl:text>
    </xsl:if>
    <xsl:text>)&#xa;</xsl:text>
    <xsl:text>&INDENT;{&#xa;</xsl:text>
    <xsl:text>&INDENT;&INDENT;</xsl:text>
    <xsl:value-of select="$transition/&SM;.Transition.effect/&ACTION;/*/&NAME;"/>
    <xsl:text>() ;&#xa;</xsl:text>
    <xsl:variable name="targetStateId" select="$transition/&SM;.Transition.target/*/@xmi.idref"/>
    <xsl:if test="$targetStateId != $transition/@xmi.id"/>
      <xsl:text>&INDENT;&INDENT;cntx.changeState(</xsl:text>
      <xsl:value-of select="key('stateKey',$targetStateId)/&NAME;"/>
      <xsl:text>::instance());&#xa;</xsl:text>    
    <xsl:text>&INDENT;}&#xa;</xsl:text>
    <xsl:text>&INDENT;else&#xa;</xsl:text>
  </xsl:template>
  
  <!-- Generate function parameters -->
  <xsl:template name="parameters">
    <xsl:for-each select="&PARAM2;[&PARAM;.kind/@xmi.value != 'return']">
      <xsl:choose>
        <xsl:when test="&PARAMTYPE;">
          <xsl:value-of select="key('dataTypeKey',&PARAMTYPE;/@xmi.idref)/&NAME;"/>
        </xsl:when>
        <xsl:when test="&PARAM;.type/&CLASS;">
          <xsl:value-of select="key('classKey',&PARAM;.type/&CLASS;/@xmi.idref)/&NAME;"/>
          <xsl:text>&amp;</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text>&#x20;</xsl:text>
      <xsl:value-of select="&NAME;"/>
      <xsl:if test="position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Generate base classes -->
  <xsl:template name="baseClass">
    <xsl:if test="&GENERALIZATION;">
      <xsl:text> : </xsl:text>
      <xsl:for-each select="&GENERALIZATION;">
        <xsl:variable name="genAssoc" select="key('generalizationKey',@xmi.idref)"/>
        <xsl:text>public </xsl:text>
        <xsl:value-of select="key('classKey',$genAssoc/&SUPERTYPE;/&CLASS;/@xmi.idref)/&NAME;"/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="getStartState">
    <xsl:param name="classId"/>
    <xsl:variable name="stateMachine"
                           select="/&STATEMACH;[&SMC;/&CLASS;/@xmi.idref = $classId]"/>
    <xsl:value-of 
                         select="$stateMachine/&PSEUDOSTATE2;
                                          [&PSEUDOSTATE;.kind/@xmi.value = 'initial']/&NAME;"/>
  </xsl:template>
</xsl:stylesheet>
