classdef Xpath < handle

    properties (Access = private, Hidden)
        domFactory;
        builder;
        xpath;
        doc;
    end
    
    methods
        
        %% Constructor 
        function obj = Xpath(xml,type)
            obj.domFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
            obj.domFactory.setNamespaceAware(true); 
            obj.builder = obj.domFactory.newDocumentBuilder();

            if (type == 'f')
                xml = fileread(xml);
            end
            
            obj.doc = obj.builder.parse(org.xml.sax.InputSource(java.io.StringReader(xml)));

            obj.xpath = javax.xml.xpath.XPathFactory.newInstance().newXPath();
        end
        
        %% Return nodes for a given map
        function n = nodes(obj, path)
            expr = obj.xpath.compile(path);
            n = expr.evaluate(obj.doc, javax.xml.xpath.XPathConstants.NODESET);    
        end
        
        %% Returns Cell Array of strings for p
        function s = string(obj, path)
            s = {};
            
            n = obj.nodes(path);
            
            if (strcmp(class(n),'java.util.ArrayList'))
                s = cell(n.toArray());
                return;
            end
            
            len = n.getLength();
            
            if len == 0
                return;
            end
            
            strAry = java_array('java.lang.String', len);
            
            for i=1:len
                strAry(i) = n.item(i-1).getNodeValue();
            end
            
            s = cell(strAry);
        end
        
        function d = date(obj, path)
            n = obj.string(path);
            d = datenum(n,'yyyy-mm-dd'); %% make this a format param later
        end
   
        function d = double(obj, path)
            n = obj.string(path);
            d = str2double(n);
        end
    end
    
end

