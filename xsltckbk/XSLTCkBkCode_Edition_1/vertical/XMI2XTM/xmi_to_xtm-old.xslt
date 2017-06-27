<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtm="http://www.topicmaps.org/xtm/1.0" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  <!--Index classes by their name -->
  <xsl:key name="classKey" match="Foundation.Core.Class" use="@xmi.id"/>
  <!-- Index Stereoptypes by both name and xmi.id -->
  <xsl:key name="stereotypeKey" match="Foundation.Extension_Mechanisms.Stereotype" use="@xmi.id"/>
  <xsl:key name="stereotypeKey" match="Foundation.Extension_Mechanisms.Stereotype" use="Foundation.Core.ModelElement.name"/>
  <!-- The xmi ids of stereoptypes used to node topic maps in UML -->
  <xsl:variable name="OCCURANCE_ID" select="key('stereotypeKey','occurance')/@xmi.id"/>
  <xsl:variable name="RESOURCE_ID" select="key('stereotypeKey','resource')/@xmi.id"/>
  <xsl:variable name="TOPIC_ID" select="key('stereotypeKey','topic')/@xmi.id"/>
  <xsl:variable name="SUBJECT_ID" select="key('stereotypeKey','subject')/@xmi.id"/>
  <xsl:variable name="BASENAME_ID" select="key('stereotypeKey','baseName')/@xmi.id"/>
  <xsl:variable name="SCOPE_ID" select="key('stereotypeKey','scope')/@xmi.id"/>
  <xsl:template match="/">
    <xtm:topicMap>
      <xsl:apply-templates mode="topics"/>
      <xsl:apply-templates mode="associations"/>
    </xtm:topicMap>
  </xsl:template>
  <!-- TOPICS -->
  <xsl:template match="Foundation.Core.Namespace.ownedElement/Foundation.Core.Class" mode="topics">
    <!-- Topics are modeled as classes whose stereotype is either empty or 'topic'  -->
    <xsl:if test="not(Foundation.Core.ModelElement.stereotype/Foundation.Extension_Mechanisms.Stereotype/@xmi.idref) or 
                        Foundation.Core.ModelElement.stereotype/Foundation.Extension_Mechanisms.Stereotype/@xmi.idref = $TOPIC_ID">
      <xsl:variable name="topicId">
        <xsl:call-template name="getTopicId">
          <xsl:with-param name="class" select="."/>
        </xsl:call-template>
      </xsl:variable>
      <xtm:topic id="{$topicId}">
        <!--This for-each is solely to change context to the optional Core.Attribute attribute named 'subjectIdentityid' -->
        <xsl:for-each select="Foundation.Core.Classifier.feature/Foundation.Core.Attribute[Foundation.Core.ModelElement.name = 'subjectIdentity']">
          <xtm:subjectIdentity>
            <xtm:subjectIdicatorRef xlink:href="{Foundation.Core.Attribute.initialValue/*/Foundation.Data_Types.Expression.body}"/>
          </xtm:subjectIdentity>
        </xsl:for-each>
        <xtm:baseName>
          <xtm:baseNameString>
            <xsl:value-of select="Foundation.Core.ModelElement.name"/>
          </xtm:baseNameString>
        </xtm:baseName>
        <xsl:call-template name="getAlternateBaseNames"/>
        <xsl:call-template name="getInstanceOf">
          <xsl:with-param name="classId" select="@xmi.id"/>
        </xsl:call-template>
        <xsl:call-template name="getOccurances"/>
      </xtm:topic>
    </xsl:if>
  </xsl:template>
  <!-- Return the topic id of a topic class which is its id attribute value or its name -->
  <xsl:template name="getTopicId">
    <xsl:param name="class"/>
    <xsl:for-each select="$class">
      <xsl:choose>
        <xsl:when test="Foundation.Core.Classifier.feature/Foundation.Core.Attribute/Foundation.Core.ModelElement.name = 'id' ">
          <!--This for-each is solely to change context to the only Core.Attribute attribute named 'id' -->
          <xsl:for-each select="Foundation.Core.Classifier.feature/Foundation.Core.Attribute[Foundation.Core.ModelElement.name = 'id']">
            <xsl:value-of select="Foundation.Core.Attribute.initialValue/*/Foundation.Data_Types.Expression.body"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="Foundation.Core.ModelElement.name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <!-- Return the subject identity of a subject class which is its subjectIdentity attribute value or its name -->
  <xsl:template name="getSubjectIdentity">
    <xsl:param name="class"/>
    <xsl:for-each select="$class">
      <xsl:choose>
        <xsl:when test="Foundation.Core.Classifier.feature/Foundation.Core.Attribute/Foundation.Core.ModelElement.name = 'subjectIdentity' ">
          <!--This for-each is solely to change context to the only Core.Attribute attribute named 'id' -->
          <xsl:for-each select="Foundation.Core.Classifier.feature/Foundation.Core.Attribute[Foundation.Core.ModelElement.name = 'subjectIdentity']">
            <xsl:value-of select="Foundation.Core.Attribute.initialValue/*/Foundation.Data_Types.Expression.body"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="Foundation.Core.ModelElement.name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="getResourceIdentity">
    <xsl:param name="class"/>
    <xsl:for-each select="$class">
      <xsl:choose>
        <xsl:when test="Foundation.Core.Classifier.feature/Foundation.Core.Attribute/Foundation.Core.ModelElement.name = 'resourceName' ">
          <!--This for-each is solely to change context to the only Core.Attribute attribute named 'id' -->
          <xsl:for-each select="Foundation.Core.Classifier.feature/Foundation.Core.Attribute[Foundation.Core.ModelElement.name = 'resourceName']">
            <xsl:value-of select="Foundation.Core.Attribute.initialValue/*/Foundation.Data_Types.Expression.body"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="Foundation.Core.ModelElement.name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="getAlternateBaseNames">
    <xsl:variable name="xmiId" select="@xmi.id"/>
    <xsl:for-each select="../Foundation.Core.Generalization[Foundation.Core.Generalization.supertype/Foundation.Core.Class/@xmi.idref = $xmiId]">
      <xsl:variable name="subtypeXmiId" select="Foundation.Core.Generalization.subtype/Foundation.Core.Class/@xmi.idref"/>
      <xsl:variable name="class" select="key('classKey',$subtypeXmiId)"/>
      <xsl:if test="$class/Foundation.Core.ModelElement.stereotype/Foundation.Extension_Mechanisms.Stereotype/@xmi.idref = $BASENAME_ID">
        <xsl:variable name="name" select="$class/Foundation.Core.ModelElement.name"/>
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
  
  <xsl:template name="getOccurances">
    <xsl:variable name="xmiId" select="@xmi.id"/>
    <xsl:for-each select="../Foundation.Core.Association[Foundation.Core.Association.connection/*/Foundation.Core.AssociationEnd.type/Foundation.Core.Class/@xmi.idref = $xmiId]">
      <xsl:if test="Foundation.Core.ModelElement.stereotype/Foundation.Extension_Mechanisms.Stereotype/@xmi.idref = $OCCURANCE_ID">
        <!--Get the id of the resource by looking at the other end of the occurance association -->
        <xsl:variable name="resourceId" select="Foundation.Core.Association.connection/*/Foundation.Core.AssociationEnd.type/Foundation.Core.Class[@xmi.idref != $xmiId]/@xmi.idref"/>
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
          <!-- We either have a resource ref or resource data. If the class has a  resourceData attribute, it is the later-->
          <xsl:variable name="resourceData">
            <xsl:for-each select="$resourceClass/Foundation.Core.Classifier.feature/Foundation.Core.Attribute[Foundation.Core.ModelElement.name = 'resourceData']">
              <xsl:value-of select="$resourceClass/Foundation.Core.Attribute.initialValue/*/Foundation.Data_Types.Expression.body"/>
            </xsl:for-each>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="string($resourceData)">
              <xtm:resourceData>
                <xsl:value-of select="$resourceData"/>
              </xtm:resourceData>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="resource">
                <xsl:call-template name="getResourceIdentity">
                  <xsl:with-param name="class" select="$resourceClass"/>
                </xsl:call-template>
              </xsl:variable>
              <resourceRef xlink:href="{$resource}"/>
            </xsl:otherwise>
          </xsl:choose>
        </xtm:occurance>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:template name="getInstanceOfBySupplier">
    <xsl:param name="classId"/>
    <xsl:call-template name="getInstanceOf">
      <xsl:with-param name="classId" select="/*/XMI.content/*/Foundation.Core.Namespace.ownedElement
                                        /Foundation.Core.Dependency
                                         [Foundation.Core.Dependency.supplier/@xmi.idref = $classId]"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template name="getInstanceOf">
    <xsl:param name="classId"/>
    <xsl:for-each select="/*/XMI.content/*/Foundation.Core.Namespace.ownedElement
                                        /Foundation.Core.Dependency
                                         [Foundation.Core.Dependency.client/
                                          Foundation.Core.Class/@xmi.idref = $classId]">
      <xtm:instanceOf>
        <xsl:variable name="instanceClass" select="key('classKey',Foundation.Core.Dependency.supplier/Foundation.Core.Class/@xmi.idref)"/>
        <!-- Figure out if instance is modeled as a subject or a topic -->
        <xsl:variable name="sterotypeId" select="$instanceClass/Foundation.Core.ModelElement.stereotype/Foundation.Extension_Mechanisms.Stereotype/@xmi.idref"/>
        <xsl:choose>
          <xsl:when test="$sterotypeId = $SUBJECT_ID">
            <xsl:variable name="subjectIdentity">
              <xsl:call-template name="getSubjectIdentity">
                <xsl:with-param name="class" select="$instanceClass"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="not(normalize-space($subjectIdentity))">
              <xsl:message terminate="yes">Subject with no identity!</xsl:message>
            </xsl:if>
            <xtm:subjectIdicatorRef xlink:href="#{$subjectIdentity}"/>
          </xsl:when>
          <xsl:when test="not($sterotypeId) or $sterotypeId = $TOPIC_ID">
            <xsl:variable name="topicId">
              <xsl:call-template name="getTopicId">
                <xsl:with-param name="class" select="$instanceClass"/>
              </xsl:call-template>
            </xsl:variable>
            <xsl:if test="not(normalize-space($topicId))">
              <xsl:message terminate="yes">Topic with no id!</xsl:message>
            </xsl:if>
            <topicRef xlink:href="#{$topicId}"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:message>
              <xsl:text>instanceOf must point to a topic or a subject. </xsl:text>
              <xsl:value-of select="$instanceClass/Foundation.Core.ModelElement.name"/>
              <xsl:text> is a </xsl:text>
              <xsl:value-of select="key('stereotypeKey',$sterotypeId)/Foundation.Core.ModelElement.name"/>
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
                         select="/*/XMI.content/*/Foundation.Core.Namespace.ownedElement
                                        /Foundation.Core.Association
                                         [Foundation.Core.Association.connection/*/
                                          Foundation.Core.AssociationEnd.type/
                                          Foundation.Core.Class/@xmi.idref = $class/@xmi.id]"/>
    <xsl:variable name="scopeAssociations" 
                         select="$classesAssociations[
                                        Foundation.Core.ModelElement.stereotype/
                                        Foundation.Extension_Mechanisms.Stereotype/
                                        @xmi.idref = $SCOPE_ID]"/>
    <xsl:if test="$scopeAssociations">
      <xtm:scope>
        <xsl:for-each select="$scopeAssociations">
          <xsl:variable name="targetClassId" select="Foundation.Core.Association.connection/*/
                                              Foundation.Core.AssociationEnd.type/
                                              Foundation.Core.Class[@xmi.idref != $class/@xmi.id]/@xmi.idref"/>
          <xsl:variable name="targetClass" select="key('classKey',$targetClassId)"/>
          <xsl:call-template name="getScopeRef">
            <xsl:with-param name="class" select="$targetClass"/>
          </xsl:call-template>
        </xsl:for-each>
      </xtm:scope>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="getScopeRef">
    <xsl:param name="class"/>
    <xsl:variable name="stereotypeId" select="$class/Foundation.Core.ModelElement.stereotype/
                                        Foundation.Extension_Mechanisms.Stereotype/
                                        @xmi.idref"/>
    <xsl:choose>
      <xsl:when test="not($stereotypeId) or $stereotypeId = $TOPIC_ID">
        <xsl:variable name="topidId">
          <xsl:call-template name="getTopicId">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:variable>
        <xtm:topicRef xlink:href="#{$topidId}"/>
      </xsl:when>
      <xsl:when test="$stereotypeId = $SUBJECT_ID">
        <xsl:variable name="subjectId">
          <xsl:call-template name="getSubjectIdentity">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:variable>
        <xtm:subjectIndicatorRef xlink:href="#{$subjectId}"/>
      </xsl:when>
      <xsl:when test="$stereotypeId = $RESOURCE_ID">
        <xsl:variable name="resourceId">
          <xsl:call-template name="getResourceIdentity">
            <xsl:with-param name="class" select="$class"/>
          </xsl:call-template>
        </xsl:variable>
        <xtm:resourceRef xlink:href="#{$resourceId}"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">A Scope must be either a topicRef, subjectRef or resourceRef!</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="text()" mode="topics"/>
  <!-- ASSOCATIONS -->
  <xsl:template match="Foundation.Core.Association" mode="associations">
    <!-- Only named UML associations are topic map associations -->
    <xsl:if test="normalize-space(Foundation.Core.ModelElement.name)">
      <xtm:asociation id="{Foundation.Core.ModelElement.name}">
        <xtm:instanceOf>
          <topicRef xlink:href="#{key('stereotypeKey',Foundation.Core.ModelElement.stereotype/Foundation.Extension_Mechanisms.Stereotype/@xmi.idref)/Foundation.Core.ModelElement.name}"/>
        </xtm:instanceOf>
        <xsl:for-each select="Foundation.Core.Association.connection/Foundation.Core.AssociationEnd">
          <xtm:member>
            <xtm:roleSpec>
              <xtm:topicRef xlink:href="#{Foundation.Core.ModelElement.name}"/>
            </xtm:roleSpec>
            <xsl:variable name="topicId">
              <xsl:call-template name="getTopicId">
                <xsl:with-param name="class" select="key('classKey',Foundation.Core.AssociationEnd.type/Foundation.Core.Class/@xmi.idref)"/>
              </xsl:call-template>
            </xsl:variable>
            <xtm:topicRef xlink:href="#{$topicId}"/>
          </xtm:member>
        </xsl:for-each>
      </xtm:asociation>
    </xsl:if>
  </xsl:template>
  <xsl:template match="text()" mode="associations"/>
</xsl:stylesheet>
