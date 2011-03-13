function [DF RATE] = getTermStructure(name,asset)
   
    % Has to be a better way than this :-(
    m = '<riskQ async="false" caller="RazorClient" environment="Razor" replicate="true" request="valuationEnquiry" server="CreditRiskServer" serverOffset="1" session="">';
    m = [m '<body><returnRates>true</returnRates><firstNode /><lastNode />'];
    m = [m '<firstPath>0</firstPath><lastPath>0</lastPath><portfolio id="-1">'];
    m = [m '<percentile>0</percentile></portfolio>'];
    m = [m '<termStructure asset="' asset '" name="' name '"/>'];
    m = [m '<returnBase>true</returnBase></body></riskQ>'];

    % Send request to razor
    xml = RazorRequest(m);

    nodes1 = xpath(xml,'//points/point/@pointDate');
    nodes2 = xpath(xml,'//points/point/value/text()');
    
    DF = ones(nodes1.getLength(),2);
    
    % JAVA collection indexing is 0 based, MATLAB is 1 based
    for i=1:nodes1.getLength()
        DF(i,1)=datenum(char(nodes1.item(i-1).getNodeValue()),'yyyy-mm-dd');
        DF(i,2)=java.lang.Double.parseDouble(nodes2.item(i-1).getNodeValue());
    end
    
    nodes1 = xpath(xml,'//rates/rate/@valueDate');
    nodes2 = xpath(xml,'//rates/rate/value/text()');
    
    RATE = ones(nodes1.getLength(),2);
    
    for i=1:nodes1.getLength()
        RATE(i,1)=datenum(char(nodes1.item(i-1).getNodeValue()),'yyyy-mm-dd');
        RATE(i,2)=java.lang.Double.parseDouble(nodes2.item(i-1).getNodeValue());
    end
  
end