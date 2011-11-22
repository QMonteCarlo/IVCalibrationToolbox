function [V,A,Omega,Alpha]=getVelocityAcceleration(P,Q,t)

n=size(P,2);
V=zeros(3,n-1);
Omega=zeros(4,n-1);
A=zeros(3,n-2);
Alpha=zeros(4,n-2);

dPdt=bsxfun(@rdivide,diff(P,1,2),diff(t,1,2));
d2Pdt2=bsxfun(@rdivide,diff(dPdt,1,2),diff(t(1:end-1),1,2));

dQdt=quaternionderivative(Q,t);
d2Qdt2=quaternionDerivative(dQdt,t(1:end-1));

Qstar=zeros(size(Q));

for i=1:n
    Qstar(:,i)=quaternionconjugate(Q(:,i));
end

for i=1:n-1
    v=quaternionproduct(quaternionproduct(Qstar(:,i),[0;dPdt(:,i)]),Q(:,i));
    V(:,i)=v(2:end);
    om=2*quaternionproduct(Qstar(:,i),dQdt(:,i));
    Omega(:,i)=om(1:end);
    if i~=n-1
        a=quaternionproduct(quaternionproduct(Qstar(:,i),[0;d2Pdt2(:,i)]),Q(:,i));
        A(:,i)=a(2:end);
        al=2*quaternionproduct(Qstar(:,i),d2Qdt2(:,i));
        Alpha(:,i)=al(1:end);
    end    
end

V=[V,V(:,end)];
Omega=[Omega,Omega(:,end)];
A=[A,A(:,end-1:end)];
Alpha=[Alpha,Alpha(:,end-1:end)];

end