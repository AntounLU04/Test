public with sharing class NumberOfConcurrence {
    public  Static Map<String,Integer> NumberOfConcurrence(List<string> values) {
        Map<String,Integer> visual=new Map<String,Integer>();

        /*for (Integer i=0 ; i<values.size();i++){
            Integer s=1;System.debug('iiii '+ values[i]);
            for(Integer j=i+1 ; j<values.size() ; j++){
                if (values[i]==values[j]){
                visual.put(values[i],++s);
                System.debug('jjj '+ values[j]);
                }
               else {
                if(!visual.containsKey(values[i])) {
                    visual.put(values[i],1);
                }
               }
            }
        }*/

        for (Integer i=0 ; i<values.size();i++){
            if(visual.containsKey(values[i])) {
                visual.put(values[i],visual.get(values[i]) + 1);
            }
            else {
                visual.put(values[i],1);
            }
        }
        return visual;
     }
}