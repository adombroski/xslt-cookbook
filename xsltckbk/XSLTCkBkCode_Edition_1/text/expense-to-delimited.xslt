<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:c="http://www.ora.com/XSLTCookbook/namespaces/cells" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl">

  <xsl:include href="cells-to-comma-delimited.xslt"/>
  
  <xsl:template match="ExpenseReport">
    <c:cell col="M" row="3" value="Statement No."/>
    <c:cell col="N" row="3" value="{@statementNum}"/>
    <c:cell col="L" row="6" value="Expense Statement"/>
    <xsl:apply-templates/>
    <xsl:variable name="offset" select="count(Expenses/Expense)+18"/>
    <c:cell col="M" row="{$offset}" value="Sub Total"/>
    <c:cell col="D" row="{$offset + 1}" value="Approved"/>
    <c:cell col="F" row="{$offset + 1}" value="Notes"/>
    <c:cell col="M" row="{$offset + 1}" value="Advances"/>
    <c:cell col="M" row="{$offset + 2}" value="Total"/>
  </xsl:template>

  <xsl:template match="Employee">
    <c:cell col="D" row="10" value="Employee"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="Employee/Name">
    <c:cell col="D" row="12" value="Name"/>
    <c:cell col="E" row="12" value="{.}"/>
  </xsl:template>

  <xsl:template match="Employee/SSN">
    <c:cell col="D" row="13" value="SSN"/>
    <c:cell col="E" row="13" value="{.}"/>
  </xsl:template>

  <xsl:template match="Employee/Dept">
    <c:cell col="D" row="14" value="Department"/>
    <c:cell col="E" row="14" value="{.}"/>
  </xsl:template>

  <xsl:template match="Employee/EmpNo">
    <c:cell col="G" row="12" value="Emp #"/>
    <c:cell col="H" row="12" value="{.}"/>
  </xsl:template>

  <xsl:template match="Employee/Position">
    <c:cell col="G" row="13" value="Position"/>
    <c:cell col="H" row="13" value="{.}"/>
  </xsl:template>

  <xsl:template match="Employee/Manager">
    <c:cell col="G" row="14" value="Manager"/>
    <c:cell col="H" row="14" value="{.}"/>
  </xsl:template>

  <xsl:template match="PayPeriod">
    <c:cell col="M" row="10" value="Pay Period"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="PayPeriod/From">
    <c:cell col="M" row="12" value="From"/>
    <c:cell col="N" row="12" value="{.}"/>
  </xsl:template>

  <xsl:template match="PayPeriod/To">
    <c:cell col="M" row="14" value="To"/>
    <c:cell col="N" row="14" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expenses">
    <c:cell col="D" row="16" value="Date"/>
    <c:cell col="E" row="16" value="Account"/>
    <c:cell col="F" row="16" value="Description"/>
    <c:cell col="G" row="16" value="Lodging"/>
    <c:cell col="H" row="16" value="Transport"/>
    <c:cell col="I" row="16" value="Fuel"/>
    <c:cell col="J" row="16" value="Meals"/>
    <c:cell col="K" row="16" value="Phone"/>
    <c:cell col="L" row="16" value="Entertainment"/>
    <c:cell col="M" row="16" value="Other"/>
    <c:cell col="N" row="16" value="Total"/>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="Expenses/Expense">
    <xsl:apply-templates>
      <xsl:with-param name="row" select="position()+16"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="Expense/Date">
    <xsl:param name="row"/>
    <c:cell col="D" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Account">
    <xsl:param name="row"/>
    <c:cell col="E" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Desc">
    <xsl:param name="row"/>
    <c:cell col="F" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Lodging">
    <xsl:param name="row"/>
    <c:cell col="G" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Transport">
    <xsl:param name="row"/>
    <c:cell col="H" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Fuel">
    <xsl:param name="row"/>
    <c:cell col="I" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Meals">
    <xsl:param name="row"/>
    <c:cell col="J" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Phone">
    <xsl:param name="row"/>
    <c:cell col="K" row="{$row}" value="{.}"/>
  </xsl:template>


  <xsl:template match="Expense/Entertainment">
    <xsl:param name="row"/>
    <c:cell col="L" row="{$row}" value="{.}"/>
  </xsl:template>

  <xsl:template match="Expense/Other">
    <xsl:param name="row"/>
    <c:cell col="M" row="{$row}" value="{.}"/>
  </xsl:template>


</xsl:stylesheet>


