<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xslt [
  <!--=============================================-->
  <!-- XMI's high level organization constructs    -->
  <!--=============================================-->
  <!ENTITY FC "Foundation.Core">
  <!ENTITY FX "Foundation.Extension_Mechanisms">
  <!ENTITY FD "Foundation.Data_Types">
  <!ENTITY MM "Model_Management.Model">
  <!ENTITY ME "&FC;.ModelElement">


  <!--===============================================-->
  <!-- Abbreviations for the basic elements of a XMI -->
  <!-- file that are of most interest to this        -->
  <!-- stylesheet.                                   -->
  <!--===============================================-->
  <!--Some generic kind of UML element -->
  <!ENTITY ELEM "&FC;.Namespace.ownedElement">
  <!--The association as a whole -->
  <!ENTITY ASSOC "&FC;.Association">
  <!--The connection part of the association-->
  <!ENTITY CONN "&ASSOC;.connection">
  <!--The ends of an association. -->
  <!ENTITY END "&ASSOC;End">
  <!ENTITY CONNEND "&CONN;/&END;">
  <!ENTITY ENDTYPE "&END;.type">
  <!-- A UML class -->
  <!ENTITY CLASS "&FC;.Class">
  <!--The name of some UML entity -->
  <!ENTITY NAME "&FC;.ModelElement.name">
  <!--A UML sterotype -->
  <!ENTITY STEREOTYPE "&ME;.stereotype/&FX;.Stereotype">
  <!--The place where UML documentation is stored in XMI. -->
  <!-- We use for resource data -->
  <!ENTITY TAGGEDVALUE 
     "&ME;.taggedValue/&FX;.TaggedValue/&FX;.TaggedValue.value">
  <!-- A Supertype relation (inheritance) -->
  <!ENTITY SUPERTYPE "&FC;.Generalization.supertype">
  <!ENTITY SUBTYPE "&FC;.Generalization.subtype">
  <!ENTITY SUPPLIER "&FC;.Dependency.supplier">
  <!ENTITY CLIENT "&FC;.Dependency.client">
  <!ENTITY DEPENDENCY 
      "/XMI/XMI.content/&MM;/&ELEM;/&FC;.Dependency">
  <!ENTITY EXPRBODY 
       "&FC;.Attribute.initialValue/&FD;.Expression/&FD;.Expression.body">
  <!ENTITY ATTR "&CLASS;ifier.feature/&FC;.Attribute">
  <!--Used for pointing at standard XTM PSIs -->
  <!ENTITY TM.ORG "http://www.topicmaps.org/xtm/index.html">
]>

<xsl:stylesheet version="1.0"  
                            xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                            xmlns:xtm="http://www.topicmaps.org/xtm/1.0" 
                            xmlns:xlink="http://www.w3.org/1999/xlink">

 <xsl:param name="termOnErr" select="true()"/>
 
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <!--Index classes by their name -->
  <xsl:key name="classKey" match="&CLASS;" use="@xmi.id"/>
  <!-- Index Stereoptypes by both name and xmi.id -->
  <xsl:key name="stereotypeKey" 
                 match="&FX;.Stereotype" use="@xmi.id"/>
  <xsl:key name="stereotypeKey"
                 match="&FX;.Stereotype" use="&NAME;"/>
  
  <!-- The xmi ids of stereoptypes used to node topic maps in UML   -->
  <!-- We use these as an efficient means for checking if a sterotype-->
  <!--  is attached to an element                                                                  -->
  <xsl:variable name="OCCURANCE_ID" 
                select="key('stereotypeKey','occurance')/@xmi.id"/>
  <xsl:variable name="RESOURCE_ID"
                select="key('stereotypeKey','resource')/@xmi.id"/>
  <xsl:variable name="TOPIC_ID"
                select="key('stereotypeKey','topic')/@xmi.id"/>
  <xsl:variable name="SUBJECT_ID"
                select="key('stereotypeKey','subject')/@xmi.id"/>
  <xsl:variable name="BASENAME_ID"
                select="key('stereotypeKey','baseName')/@xmi.id"/>
  <xsl:variable name="SCOPE_ID"
                select="key('stereotypeKey','scope')/@xmi.id"/>
  <xsl:variable name="VARIANT_ID"
                select="key('stereotypeKey','variant')/@xmi.id"/>

  
  <xsl:template match="/">
    <xtm:topicMap>
      <xsl:apply-templates mode="topics"/>
      <xsl:apply-templates mode="associations"/>
    </xtm:topicMap>
  </xsl:template>
  
  <!--=====================================-->
  <!-- UML Classes to TOPICS  Translation  -->
  <!--=====================================-->
  
  <xsl:template match="&ELEM;/&CLASS;" mode="topics">
    <!-- Topics are modeled as classes whose    -->
    <!-- stereotype is either empty or 'topic'  -->
    <xsl:if test="not(&STEREOTYPE;/@xmi.idref) or 
                        &STEREOTYPE;/@xmi.idref = $TOPIC_ID">
      <xsl:variable name="topicId">
        <xsl:call-template name="getTopicId">
          <xsl:with-param name="class" select="."/>
          <xsl:with-param name="prefix" select="''"/>
        </xsl:call-template>
      </xsl:variable>
      <xtm:topic id="{$topicId}">
        <!--This for-each is solely to change context to the optional -->
        <!-- Core.Attribute attribute named 'subjectIdentityid' -->
        <xsl:for-each select="&ATTR;[&NAME; = 'subjectIdentity']">
          <xtm:subjectIdentity>
            <xtm:subjectIdicatorRef xlink:href="{&EXPRBODY;}"/>
          </xtm:subjectIdentity>
        </xsl:for-each>
        <xtm:baseName>
          <xtm:baseNameString>
            <xsl:value-of select="&NAME;"/>
          </xtm:baseNameString>
        </xtm:baseName>
        <xsl:call-template name="getAlternateBaseNames"/>
        <xsl:call-template name="getVariants"/>
        <xsl:call-template name="getInstanceOf">
          <xsl:with-param name="classId" select="@xmi.id"/>
        </xsl:call-template>
        <xsl:call-template name="getOccurances"/>
      </xtm:topic>
    </xsl:if>
  </xsl:template>
  
  <!-- Return the topic id of a topic class which is its id -->
  <!-- attribute value or its name -->
  <xsl:template name="getTopicId">
    <xsl:param name="class"/>
    <xsl:param name="prefix" select="'#'"/>
    <xsl:for-each select="$class">
      <xsl:choose>
        <xsl:when test="&ATTR;/&NAME; = 'id' ">
          <!--This for-each is solely to change context to the -->
          <!-- only Core.Attribute attribute named 'id' -->
          <xsl:for-each select="&ATTR;[&NAME; = 'id']">
            <xsl:value-of select="&EXPRBODY;"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat($prefix,&NAME;)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Return the subject identity of a subject class which -->
  <!-- is its subjectIdentity attribute value or its name -->
  <xsl:template name="getSubjectIdentity">
    <xsl:param name="class"/>
    <xsl:for-each select="$class">
      <xsl:choose>
        <xsl:when test="&ATTR;/&NAME; = 'subjectIdentity' ">
          <!--This for-each is solely to change context to the only -->
          <!-- Core.Attribute attribute named 'subjectIdentity' -->
          <xsl:for-each select="&ATTR;[&NAME; = 'subjectIdentity']">
            <xsl:value-of select="&EXPRBODY;"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('#',&NAME;)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <!-- Return the resource identity of a resource class which -->
  <!-- is either its resourceName attribute or its name -->
  <xsl:template name="getResourceIdentity">
    <xsl:param name="class"/>
    <xsl:for-each select="$class">
      <xsl:choose>
        <xsl:when test="&ATTR;/&NAME; = 'resourceName' ">
          <!--This for-each is solely to change context to the only -->
          <!-- Core.Attribute attribute named 'resourceName' -->
          <xsl:for-each select="&ATTR;[&NAME; = 'resourceName']">
            <xsl:value-of select="&EXPRBODY;"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('#',&NAME;)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Alternate base names are found by traversing UML -->
  <!-- generalization relationships and looking for baseName -->
  <!-- sterotypes -->
  
  <xsl:template name="getAlternateBaseNames">
    <xsl:variable name="xmiId" select="@xmi.id"/>
    <xsl:for-each select="../&FC;.Generalization
                          [&SUPERTYPE;/&CLASS;/@xmi.idref = $xmiId]">
      <xsl:variable name="subtypeXmiId"
                    select="&FC;.Generalization.subtype/&CLASS;/@xmi.idref"/>
      <xsl:variable name="class" select="key('classKey',$subtypeXmiId)"/>
      <xsl:if test="$class/&STEREOTYPE;/@xmi.idref = $BASENAME_ID">
        <xsl:variable name="name" select="$class/&NAME;"/>
        <xtm:baseName>
          <xsl:call-template name="getScope">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
          <xtm:baseNameString>
            <xsl:value-of select="substring-after($name,'::')"/>
          </xtm:baseNameString>
        </xtm:baseName>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Variants are found by traversing UML -->
  <!-- generalization relationships and looking for baseName -->
  <!-- sterotypes -->

  <xsl:template name="getVariants">
    <xsl:variable name="xmiId" select="@xmi.id"/>
    <xsl:for-each select="../&FC;.Generalization
                           [&SUPERTYPE;/&CLASS;/@xmi.idref = $xmiId]">
      <xsl:variable name="subtypeXmiId"
                    select="&FC;.Generalization.subtype/&CLASS;/@xmi.idref"/>
      <xsl:variable name="variantClass"
                    select="key('classKey',$subtypeXmiId)"/>
      <xsl:if test="$variantClass/&STEREOTYPE;/@xmi.idref = $VARIANT_ID">
        <xsl:variable name="name" select="$variantClass/&NAME;"/>
        <xtm:variant>
          <xtm:variantName>
            <xsl:call-template name="resourceRep">
              <xsl:with-param name="class" select="$variantClass"/>
            </xsl:call-template>
          </xtm:variantName>
          <xtm:parameters>
            <xsl:call-template name="getVariantParams">
              <xsl:with-param name="class" select="$variantClass"/>
            </xsl:call-template>
          </xtm:parameters>
          <!--Change context to this variant to get nested variants, if any -->
          <xsl:for-each select="$variantClass">
            <xsl:call-template name="getVariants"/>
          </xsl:for-each>
        </xtm:variant>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Gets a variant's parameters from   -->
  <!-- the attibutes of the variant class -->
  <xsl:template name="getVariantParams">
    <xsl:param name="class"/>
    <xsl:if test="not($class/&ATTR;)">
      <xsl:message terminate="{$termOnErr}">
      A variant must have at least one parameter.
      </xsl:message>
    </xsl:if>
    <xsl:for-each select="$class/&ATTR;">
      <!-- A parameter is either modeld as a subject indicator  --> 
      <!-- or topic ref                                         -->
      <xsl:choose>
        <xsl:when test="&STEREOTYPE;/@xmi.idref = $SUBJECT_ID">
            <xtm:subjectIdicatorRef xlink:href="{&EXPRBODY;}"/>
        </xsl:when>
        <xsl:otherwise>
            <xtm:topicRef  xlink:href="{&EXPRBODY;}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <!-- Topic map occurances are modeled as associations to -->
  <!-- classes containing resource references or data -->
  <xsl:template name="getOccurances">
    <xsl:variable name="xmiId" select="@xmi.id"/>
    <!--Search over the associations this class participates-->
    <xsl:for-each 
            select="../&ASSOC;
                            [&CONN;/*/&ENDTYPE;/&CLASS;/@xmi.idref = $xmiId]">
       <!-- Test for the presence of the occurance stereotype -->                     
      <xsl:if test="&STEREOTYPE;/@xmi.idref = $OCCURANCE_ID">
        <!--Get the id of the resource by looking at the other end -->
        <!-- of the occurance association -->
        <xsl:variable name="resourceId" 
                      select="&CONN;/*/&ENDTYPE;/&CLASS;
                                [@xmi.idref != $xmiId]/@xmi.idref"/>
        <!-- Get the class representing the resource -->
        <xsl:variable name="resourceClass" select="key('classKey',$resourceId)"/>
        <xtm:occurance>
          <xsl:call-template name="getInstanceOf">
            <xsl:with-param name="classId" select="$resourceId"/>
          </xsl:call-template>
          <!--TODO: Can't model this yet!
            <xsl:call-template name="getScope">
              <xsl:with-param name="class"/>
            </xsl:call-template>
          -->
          <!-- We either have a resource ref or resource data. -->
          <!-- If the class has a  resourceData attribute it   -->
          <!-- is the later.                                   -->
          <xsl:call-template name="resourceRep">
            <xsl:with-param name="class" select="$resourceClass"/>
          </xsl:call-template>
        </xtm:occurance>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- This template determines how the resource is represented -->
  <xsl:template name="resourceRep">
      <xsl:param name="class" />
      <xsl:variable name="resourceData">
        <!--for-each to change context -->
        <xsl:for-each select="$class/&ATTR;[&NAME; = 'resourceData']">
          <xsl:choose>
            <!--The resource data was encoded in the UML attr -->
            <!--documentation                                 --> 
            <xsl:when test="&TAGGEDVALUE;">
              <xsl:value-of select="&TAGGEDVALUE;"/>
            </xsl:when>
            <!--The resource data was encoded in the UML attr value -->
            <xsl:otherwise>
              <xsl:value-of select="&EXPRBODY;"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <!-- if we found some resource data then use it. -->
      <!-- Otherwise assume the user meant this to be a reference -->
      <xsl:choose>
        <xsl:when test="string($resourceData)">
          <xtm:resourceData>
            <xsl:value-of select="$resourceData"/>
          </xtm:resourceData>
        </xsl:when>
        <xsl:otherwise>
          <xsl:variable name="resource">
            <xsl:call-template name="getResourceIdentity">
              <xsl:with-param name="class" select="$class"/>
            </xsl:call-template>
          </xsl:variable>
          <xtm:resourceRef xlink:href="{$resource}"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  
  <!-- This template finds if a topic class has any instanceOf -->
  <!-- associations. -->
  <xsl:template name="getInstanceOf">
    <xsl:param name="classId"/>
    <!-- We loop of dependency relations and determine  -->
    <!-- how the instance is represented-->
    <xsl:for-each 
            select="&DEPENDENCY;[&CLIENT;/&CLASS;/@xmi.idref = $classId]">
      <xtm:instanceOf>
        <xsl:variable name="instanceClass"
                      select="key('classKey',&SUPPLIER;/&CLASS;/@xmi.idref)"/>
        <!-- Figure out if instance is modeled as a subject or a topic -->
        <xsl:variable name="sterotypeId"
                      select="$instanceClass/&STEREOTYPE;/@xmi.idref"/>
        <xsl:choose>
          <!-- This is the case of a subject indicator -->
          <xsl:when test="$sterotypeId = $SUBJECT_ID">
            <xsl:variable name="subjectIdentity">
              <xsl:call-template name="getSubjectIdentity">
                <xsl:with-param name="class" select="$instanceClass"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="not(normalize-space($subjectIdentity))">
              <xsl:message terminate="{$termOnErr}">
              Subject with no identity!
              </xsl:message>
            </xsl:if>
            <xtm:subjectIdicatorRef xlink:href="{$subjectIdentity}"/>
          </xsl:when>
          <!-- Otheriwse the instance is represented by a topic -->
          <xsl:when test="not($sterotypeId) or $sterotypeId = $TOPIC_ID">
            <xsl:variable name="topicId">
              <xsl:call-template name="getTopicId">
                <xsl:with-param name="class" select="$instanceClass"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="not(normalize-space($topicId))">
              <xsl:message terminate="{$termOnErr}">
              Topic with no id!
              </xsl:message>
            </xsl:if>
            <topicRef xlink:href="{$topicId}"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message terminate="{$termOnErr}">
              <xsl:text>instanceOf must point to a topic or a subject. </xsl:text>
              <xsl:value-of select="$instanceClass/&NAME;"/>
              <xsl:text> is a </xsl:text>
              <xsl:value-of select="key('stereotypeKey',$sterotypeId)/&NAME;"/>
              <xsl:text>.&#xa;</xsl:text>
            </xsl:message>
          </xsl:otherwise>
        </xsl:choose>
      </xtm:instanceOf>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="getScope">
    <xsl:param name="class"/>
    <xsl:variable name="classesAssociations"
                  select="/*/XMI.content/*/&ELEM;
                          /&ASSOC;
                          [&CONN;/*/
                          &FC;.AssociationEnd.type/
                          &CLASS;/@xmi.idref = $class/@xmi.id]"/>
    <xsl:variable name="scopeAssociations" 
                  select="$classesAssociations[
                          &FC;.ModelElement.stereotype/
                          &FX;.Stereotype/
                          @xmi.idref = $SCOPE_ID]"/>
    <xsl:if test="$scopeAssociations">
      <xtm:scope>
        <xsl:for-each select="$scopeAssociations">
          <xsl:variable name="targetClassId"
                        select="&CONN;/*/&ENDTYPE;/&CLASS;
                                [@xmi.idref != $class/@xmi.id]/@xmi.idref"/>
          <xsl:variable name="targetClass" 
                        select="key('classKey',$targetClassId)"/>
          <xsl:call-template name="getScopeRef">
            <xsl:with-param name="class" select="$targetClass"/>
          </xsl:call-template>
        </xsl:for-each>
      </xtm:scope>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="getScopeRef">
    <xsl:param name="class"/>
    <xsl:variable name="stereotypeId" 
                  select="$class/&FC;.ModelElement.stereotype/
                          &FX;.Stereotype/
                          @xmi.idref"/>
    <xsl:choose>
      <xsl:when test="not($stereotypeId) or $stereotypeId = $TOPIC_ID">
        <xsl:variable name="topidId">
          <xsl:call-template name="getTopicId">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:variable>
        <xtm:topicRef xlink:href="{$topidId}"/>
      </xsl:when>
      <xsl:when test="$stereotypeId = $SUBJECT_ID">
        <xsl:variable name="subjectId">
          <xsl:call-template name="getSubjectIdentity">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:variable>
        <xtm:subjectIndicatorRef xlink:href="{$subjectId}"/>
      </xsl:when>
      <xsl:when test="$stereotypeId = $RESOURCE_ID">
        <xsl:variable name="resourceId">
          <xsl:call-template name="getResourceIdentity">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:variable>
        <xtm:resourceRef xlink:href="{$resourceId}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="{$termOnErr}">
        A Scope must be either a topicRef, subjectRef or resourceRef!
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="text()" mode="topics"/>
  
  <!--=====================================-->
  <!-- UML ASSOCIATION TO TOPIC ASSOCATIONS -->
  <!--=====================================-->
  <xsl:template match="&ASSOC;" mode="associations">
    <!-- Only named UML associations are topic map associations -->
    <xsl:if test="normalize-space(&NAME;)">
      <xtm:asociation id="{&NAME;}">
        <xtm:instanceOf>
          <topicRef
            xlink:href="{key('stereotypeKey',
                             &STEREOTYPE;/@xmi.idref)/&NAME;}"/>
        </xtm:instanceOf>
        <xsl:for-each select="&CONNEND;">
          <xtm:member>
            <xtm:roleSpec>
              <xtm:topicRef xlink:href="{&NAME;}"/>
            </xtm:roleSpec>
            <xsl:variable name="topicId">
              <xsl:call-template name="getTopicId">
                <xsl:with-param name="class"
                        select="key('classKey',
                                    &ENDTYPE;/&CLASS;/@xmi.idref)"/>
              </xsl:call-template>
            </xsl:variable>
            <xtm:topicRef xlink:href="{$topicId}"/>
          </xtm:member>
        </xsl:for-each>
      </xtm:asociation>
    </xsl:if>
  </xsl:template>

  <xsl:template match="&ELEM;/&FC;.Generalization"
                mode="associations">

    <xsl:variable name="subClassId"
                  select="&SUBTYPE;/&CLASS;/@xmi.idref"/>
    <xsl:variable name="subClass"
                  select="key('classKey',$subClassId)"/>
    <xsl:variable name="superClassId"
                  select="&SUPERTYPE;/&CLASS;/@xmi.idref"/>
    <xsl:variable name="superClass"
                  select="key('classKey',$superClassId)"/>
    
    <!-- If a generalization relation exists from a topic to a -->
    <!-- topic we use this as an indication of a canonical     -->    
    <!-- superclass-subclass relation, Ideally we would use an --> 
    <!-- absence of a stereotype on the generalization but the -->
    <!-- version of XMI I am using is not storing stereotype   -->
    <!-- info for generalizations                              -->
    <xsl:if test="(not($subClass/&STEREOTYPE;/@xmi.idref) or 
                        $subClass/&STEREOTYPE;/@xmi.idref = $TOPIC_ID) and
                        (not($superClass/&STEREOTYPE;/@xmi.idref) or 
                        $superClass/&STEREOTYPE;/@xmi.idref = $TOPIC_ID)">
                        
      <xtm:asociation>
        <xsl:variable name="id">
          <xsl:choose>
            <xsl:when test="normalize-space(&NAME;)">
              <xsl:value-of select="&NAME;"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@xmi.id"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:attribute name="id">
          <xsl:value-of select="$id"/>
        </xsl:attribute>
        
        <xtm:instanceOf>
          <subjectIndicatorRef 
             xlink:href="&TM.ORG;#psi-superclass-subclass"/>
        </xtm:instanceOf>
        
        <xtm:member>
        
          <xtm:roleSpec>
            <xtm:subjectIndicatorRef xlink:href="&TM.ORG;#psi-superclass"/>
          </xtm:roleSpec>
          
          <xsl:variable name="superClassTopicId">
            <xsl:call-template name="getTopicId">
              <xsl:with-param name="class" select="$superClass"/>
            </xsl:call-template>
          </xsl:variable>
          <xtm:topicRef xlink:href="{$superClassTopicId}"/>
          
        </xtm:member>
        
        <xtm:member>
          <xtm:roleSpec>
            <xtm:subjectIndicatorRef xlink:href="&TM.ORG;#psi-subclass"/>
          </xtm:roleSpec>
          
          <xsl:variable name="subClassTopicId">
            <xsl:call-template name="getTopicId">
              <xsl:with-param name="class" select="$subClass"/>
            </xsl:call-template>
          </xsl:variable>

          <xtm:topicRef xlink:href="{$subClassTopicId}"/>
        </xtm:member>
        
      </xtm:asociation>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="text()" mode="associations"/>
  
</xsl:stylesheet>
